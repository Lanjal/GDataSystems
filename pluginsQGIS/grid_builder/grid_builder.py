# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QSettings, QTranslator, QCoreApplication
from qgis.PyQt.QtGui import QIcon, QIntValidator
from qgis.PyQt.QtWidgets import QAction,QMessageBox
from .resources import *
from .grid_builder_dialog import GridBuilderDialog
import os.path
from qgis.core import QgsProject, QgsPointXY, QgsGeometry, QgsVectorLayer,QgsFeature, QgsPoint, QgsField, QgsMapLayerType, QgsWkbTypes

class GridBuilder:

    def __init__(self, iface):
        self.iface = iface
        self.plugin_dir = os.path.dirname(__file__)
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(
            self.plugin_dir,
            'i18n',
            'GridBuilder_{}.qm'.format(locale))

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)

        self.actions = []
        self.menu = self.tr(u'&Grid Builder')
        self.first_start = None

    def tr(self, message):
        return QCoreApplication.translate('GridBuilder', message)

    def add_action(
        self,
        icon_path,
        text,
        callback,
        enabled_flag=True,
        add_to_menu=True,
        add_to_toolbar=True,
        status_tip=None,
        whats_this=None,
        parent=None):
        icon = QIcon(icon_path)
        action = QAction(icon, text, parent)
        action.triggered.connect(callback)
        action.setEnabled(enabled_flag)
        if status_tip is not None:
            action.setStatusTip(status_tip)

        if whats_this is not None:
            action.setWhatsThis(whats_this)

        if add_to_toolbar:
            self.iface.addToolBarIcon(action)

        if add_to_menu:
            self.iface.addPluginToMenu(
                self.menu,
                action)

        self.actions.append(action)
        return action

    def initGui(self):
        icon_path = ':/plugins/grid_builder/icon.png'
        self.add_action(
            icon_path,
            text=self.tr(u'Grid Builder'),
            callback=self.run,
            parent=self.iface.mainWindow())

        self.first_start = True

    def unload(self):
        for action in self.actions:
            self.iface.removePluginMenu(
                self.tr(u'&Grid Builder'),
                action)
            self.iface.removeToolBarIcon(action)

    def run(self):
        if self.first_start == True:
            self.first_start = False
            self.dlg = GridBuilderDialog()
            self.dlg.mMapLayerComboBox.setShowCrs(True)
            self.map_layers = QgsProject.instance().mapLayers().values()
            self.allow_list = [
                                lyr.id() for lyr in self.map_layers if lyr.type() == QgsMapLayerType.VectorLayer
                                and lyr.geometryType()== QgsWkbTypes.PolygonGeometry 
                            ]
            self.except_list = [l for l in self.map_layers if l.id() not in self.allow_list]
            self.dlg.mMapLayerComboBox.setExceptedLayerList(self.except_list)
            onlyInt = QIntValidator()
            self.dlg.lineEditSpY.setText('400')
            self.dlg.lineEditSpY.setValidator(onlyInt)
            self.dlg.lineEditSpX.setText('200')
            self.dlg.lineEditSpX.setValidator(onlyInt)
            self.dlg.lineEditRota.setText('0')
            self.dlg.lineEditRota.setValidator(onlyInt)
            self.dlg.lineEditBuf.setText('1000')
            self.dlg.lineEditBuf.setValidator(onlyInt)

        self.dlg.show()
        result = self.dlg.exec_()
        if result:
            if self.dlg.lineEditSpY.text()=='' or self.dlg.lineEditSpX.text()=='' or self.dlg.lineEditRota.text()=='' or self.dlg.lineEditBuf.text()=='':
                QMessageBox.warning(self.iface.mainWindow(),
                         'Error',
                         "Please enter all the fields \nLeaving...")
                return
            layer = self.dlg.mMapLayerComboBox.currentLayer()
            feats = [ feat for feat in layer.getFeatures()]
            points = []
            spacing_y = int(self.dlg.lineEditSpY.text())
            spacing_x = int(self.dlg.lineEditSpX.text())
            rotacao= int(self.dlg.lineEditRota.text())
            extensao= int(self.dlg.lineEditBuf.text())
            #executar o código
            #------------------
            #
            for feat in feats:
                centroid = feat.geometry().centroid().asPoint()
                extent = feat.geometry().boundingBox()
                xmin=int(round(extent.xMinimum()-extensao, -2))
                ymin=int(round(extent.yMinimum()-extensao, -2))
                xmax=int(round(extent.xMaximum()+extensao, -2))
                ymax=int(round(extent.yMaximum()+extensao, -2))
                rows = int(((ymax) - (ymin))/spacing_y)
                cols = int(((xmax) - (xmin))/spacing_x)
                x = xmin
                y = ymax
                geom_feat = feat.geometry()
                for i in range(rows+1):
                    for j in range(cols+1):
                        pt = QgsPointXY(x,y)
                        tmp_pt = QgsGeometry.fromPointXY(pt)
                        tmp_pt.rotate(rotacao, centroid)
                        if tmp_pt.within(geom_feat):
                            points.append(tmp_pt.asPoint())
                        x += spacing_x
                    x = xmin
                    y -= spacing_y

            epsg = layer.crs().postgisSrid()
            #gerando pontos
            uri = "PointZ?crs=epsg:" + str(epsg) + "&field=id:integer""&index=yes"
            mem_layer = QgsVectorLayer(uri,'gridpoints','memory')
            prov = mem_layer.dataProvider()
            feats = [ QgsFeature() for i in range(len(points)) ]
            for i, feat in enumerate(feats):
                feat.setAttributes([i])
                feat.setGeometry(QgsPoint(points[i].x(),points[i].y(),0.0))

            prov.addFeatures(feats)
            QgsProject.instance().addMapLayer(mem_layer)
            QMessageBox.information(self.iface.mainWindow(),
                         'Ready',
                         "Sampling Points Created!")
            return
