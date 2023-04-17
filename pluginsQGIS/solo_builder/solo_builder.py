# -*- coding: utf-8 -*-
"""
-------------------------------------------------------------------------------
   Copyright (C) 2023 GDataSystems <andre.costa@grupoge21.com>

 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the is licensed under the BSD 3-Clause "New" or
 *   "Revised" License.
-------------------------------------------------------------------------------
"""
from qgis.PyQt.QtCore import QSettings, QTranslator, QCoreApplication, QVariant
from qgis.PyQt.QtGui import QIcon, QIntValidator
from qgis.gui import QgsFieldComboBox, QgsMapLayerComboBox
from qgis.PyQt.QtWidgets import QAction, QMessageBox, QMenu
from .resources import *
from .solo_builder_dialog import SoloBuilderDialog
import os.path
from qgis.core import QgsProject, QgsPointXY, QgsGeometry, QgsVectorLayer,QgsFeature, QgsPoint, QgsField, QgsMapLayerType, QgsWkbTypes

class SoloBuilder:
    def __init__(self, iface):
        self.iface = iface
        self.plugin_dir = os.path.dirname(__file__)
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(
            self.plugin_dir,
            'i18n',
            'SoloBuider_{}.qm'.format(locale))

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)

        self.actions = []
        self.menu = self.tr(u'&GDataSystems Solo')
        self.first_start = None

    def tr(self, message):
        return QCoreApplication.translate('SoloBuilder', message)

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
        icon_path = ':/plugins/solo_builder/icon.png'
        self.add_action(
            icon_path,
            text=self.tr(u'GDS-Criar Pontos Solo'),
            callback=self.run,
            parent=self.iface.mainWindow())
        
        self.first_start = True

    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""
        for action in self.actions:
            self.iface.removePluginMenu(
                self.tr(u'&GDS-Criar Pontos Solo'),
                action)
            self.iface.removeToolBarIcon(action)

    def run(self):
        if self.first_start == True:
            self.first_start = False
            self.dlg = SoloBuilderDialog()
            self.dlg.mMapLayerComboBox.setShowCrs(True)
            self.map_layers = QgsProject.instance().mapLayers().values()
            self.allow_list = [
                                lyr.id() for lyr in self.map_layers if lyr.type() == QgsMapLayerType.VectorLayer
                                and lyr.geometryType()== QgsWkbTypes.PolygonGeometry 
                                and lyr.name()=='dm2' 
                            ]
            self.except_list = [l for l in self.map_layers if l.id() not in self.allow_list]
            self.dlg.mMapLayerComboBox.setExceptedLayerList(self.except_list)
            onlyInt = QIntValidator()
            self.dlg.lineEditSpY.setText('400')
            self.dlg.lineEditSpY.setValidator(onlyInt)
            self.dlg.lineEditSpX.setText('50')
            self.dlg.lineEditSpX.setValidator(onlyInt)
            self.dlg.lineEditRota.setText('0')
            self.dlg.lineEditRota.setValidator(onlyInt)
            self.dlg.lineEditBuf.setText('1000')
            self.dlg.lineEditBuf.setValidator(onlyInt)
            

        self.dlg.show()
        result = self.dlg.exec_()
        if result:
            #Checar se campos entrados são válidos
            #---------------
            if self.dlg.lineEditSpY.text()=='' or self.dlg.lineEditSpX.text()=='' or self.dlg.lineEditRota.text()=='' or self.dlg.lineEditBuf.text()=='' or self.dlg.lineEditProjeto.text()=='' or self.dlg.lineEditAlvo.text()=='' or self.dlg.lineEditQuem.text()=='' or self.dlg.lineEditPrefix.text()=='':
                QMessageBox.warning(self.iface.mainWindow(),
                         'Erro',
                         "Entrar todo os campos do formulário\nSaindo...")
                return
            layer = self.dlg.mMapLayerComboBox.currentLayer()
            feats = [ feat for feat in layer.getFeatures()]
            points = []
            spacing_y = int(self.dlg.lineEditSpY.text())
            spacing_x = int(self.dlg.lineEditSpX.text())
            rotacao= int(self.dlg.lineEditRota.text())
            extensao= int(self.dlg.lineEditBuf.text())
            datumlbl=self.dlg.comboBoxDatum.currentText()
            zonevl=int(self.dlg.comboBoxZona.currentText())
            nslbl=self.dlg.comboBoxNs.currentText()
            projetolbl=self.dlg.lineEditProjeto.text()
            alvolbl=self.dlg.lineEditAlvo.text()
            quem=self.dlg.lineEditQuem.text()
            prefix=self.dlg.lineEditPrefix.text()
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
            mem_layer = QgsVectorLayer(uri,'soil2','memory')
            prov = mem_layer.dataProvider()
            feats = [ QgsFeature() for i in range(len(points)) ]
            for i, feat in enumerate(feats):
                feat.setAttributes([i])
                feat.setGeometry(QgsPoint(points[i].x(),points[i].y(),0.0))

            prov.addFeatures(feats)
            QgsProject.instance().addMapLayer(mem_layer)
            # Adicionando campos extra
            v1 = QgsProject().instance().mapLayersByName('soil2')[0]
            pr = v1.dataProvider()
            pr.addAttributes([QgsField("projeto", QVariant.String),QgsField("alvo", QVariant.String),QgsField("ponto", QVariant.String),QgsField("amostra", QVariant.String),QgsField("duplicata", QVariant.String),QgsField("branco", QVariant.String),QgsField("padrao", QVariant.String),QgsField("reamostra", QVariant.String),QgsField("tipo", QVariant.String),QgsField("utme", QVariant.Double),QgsField("utmn", QVariant.Double),QgsField("elev", QVariant.Double),QgsField("datum", QVariant.String),QgsField("_zone",  QVariant.Int),QgsField("ns", QVariant.String),QgsField("tipoperfil", QVariant.String),QgsField("profm", QVariant.Double),QgsField("cor", QVariant.String),QgsField("tipoamostr", QVariant.String),QgsField("granul", QVariant.String),QgsField("relevo", QVariant.String),QgsField("fragmentos", QVariant.String),QgsField("magnetismo", QVariant.String),QgsField("vegetacao", QVariant.String),QgsField("peso", QVariant.Double),QgsField("resp", QVariant.String),QgsField("_data", QVariant.Date),QgsField("obs", QVariant.String),QgsField("coletado", QVariant.Bool),QgsField("tstp", QVariant.DateTime),QgsField("who", QVariant.String)])
            v1.updateFields()
            # colocando valores default nas colunas fixas
            layer = QgsProject().instance().mapLayersByName('soil2')[0]
            prov = layer.dataProvider()
            datum_idx = layer.fields().lookupField('datum')
            zone_idx = layer.fields().lookupField('_zone')
            ns_idx = layer.fields().lookupField('ns')
            utmn_idx = layer.fields().lookupField('utmn')
            utme_idx = layer.fields().lookupField('utme')
            elev_idx = layer.fields().lookupField('elev')
            projeto_idx = layer.fields().lookupField('projeto')
            alvo_idx = layer.fields().lookupField('alvo')
            who_idx = layer.fields().lookupField('who')
            ponto_idx = layer.fields().lookupField('ponto')
            coletado_idx = layer.fields().lookupField('coletado')
            atts = {datum_idx: datumlbl, zone_idx: zonevl, ns_idx: nslbl,utmn_idx: 0.0, utme_idx: 0.0, elev_idx: 0.0,projeto_idx: projetolbl, alvo_idx: alvolbl, who_idx: quem, coletado_idx: False}
            for line in layer.getFeatures():
                prov.changeAttributeValues({line.id(): {ponto_idx: prefix+str(line.id()-1)}})

            for line in layer.getFeatures():
                prov.changeAttributeValues({line.id(): atts})

            QMessageBox.information(self.iface.mainWindow(),
                         'Pronto',
                         "Camada de Pontos Criada!")
            return
