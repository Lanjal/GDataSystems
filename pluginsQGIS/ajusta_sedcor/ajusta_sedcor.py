# -*- coding: utf-8 -*-
"""
-------------------------------------------------------------------------------
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the is licensed under the BSD 3-Clause "New" or *
 *   "Revised" License.
 *                                                                         *
-------------------------------------------------------------------------------
"""
from qgis.PyQt.QtCore import QSettings, QTranslator, QCoreApplication, QVariant
from qgis.PyQt.QtGui import QIcon
from qgis.gui import QgsFieldComboBox, QgsMapLayerComboBox
from qgis.PyQt.QtWidgets import QAction, QMessageBox, QMenu
from .resources import *
from .ajusta_sedcor_dialog import AjustaSedcorDialog
import os.path
from qgis.core import QgsProject,QgsFeature, QgsPoint, QgsField, QgsVectorLayer,QgsVectorFileWriter, QgsMapLayerType, QgsWkbTypes
from qgis import processing

class AjustaSedcor:
    def __init__(self, iface):
        self.iface = iface
        self.plugin_dir = os.path.dirname(__file__)
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(
            self.plugin_dir,
            'i18n',
            'AjustaSedcor_{}.qm'.format(locale))

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)

        self.actions = []
        self.menu = self.tr(u'GDataSystems Sedcor')
        self.first_start = None

    def tr(self, message):
        return QCoreApplication.translate('AjustaSedcor', message)

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
        icon_path = ':/plugins/ajusta)sedcor/icon.png'
        self.add_action(
            icon_path,
            text=self.tr(u'&GDS-Ajusta Sedcor'),
            callback=self.run,
            parent=self.iface.mainWindow())

        self.first_start = True

    def unload(self):
        for action in self.actions:
            self.iface.removePluginMenu(
                self.tr(u'&GDS-Ajusta Sedcor'),
                action)
            self.iface.removeToolBarIcon(action)

    def run(self):
        if self.first_start == True:
            self.first_start = False
            self.dlg = AjustaSedcorDialog()
            self.dlg.mMapLayerComboBox.setShowCrs(True)
            self.map_layers = QgsProject.instance().mapLayers().values()
            self.allow_list = [
                                lyr.id() for lyr in self.map_layers if lyr.type() == QgsMapLayerType.VectorLayer
                                and lyr.geometryType()== QgsWkbTypes.PointGeometry 
                                and lyr.name()=='pontosed' 
                            ]
            self.except_list = [l for l in self.map_layers if l.id() not in self.allow_list]
            self.dlg.mMapLayerComboBox.setExceptedLayerList(self.except_list)

        self.dlg.show()
        result = self.dlg.exec_()
        if result:
            #Checar se campos entrados são válidos
            #---------------
            if self.dlg.lineEditProjeto.text()=='' or self.dlg.lineEditAlvo.text()=='' or self.dlg.lineEditQuem.text()=='' or self.dlg.lineEditPrefix.text()=='':
                QMessageBox.warning(self.iface.mainWindow(),
                         'Erro',
                         "Entrar todo os campos do formulário\nSaindo...")
                return
            layer = self.dlg.mMapLayerComboBox.currentLayer()
            datumlbl=self.dlg.comboBoxDatum.currentText()
            zonevl=int(self.dlg.comboBoxZona.currentText())
            nslbl=self.dlg.comboBoxNs.currentText()
            projetolbl=self.dlg.lineEditProjeto.text()
            alvolbl=self.dlg.lineEditAlvo.text()
            quem=self.dlg.lineEditQuem.text()
            prefix=self.dlg.lineEditPrefix.text()
            csv = self.dlg.mQgsFileWidget.filePath()
            
            epsg = layer.crs().postgisSrid()
            uri = "PointZ?crs=epsg:" + str(epsg) + "&field=id:integer""&index=yes"
            mem_layer = QgsVectorLayer(uri,'sed2','memory')
            prov1 = mem_layer.dataProvider()
            feats = [ QgsFeature() for i in range(len(layer)) ]
            for i, feat in enumerate(feats):
                feature = layer.getFeature(i) 
                point = feature.geometry().asPoint()
                x, y = point.x(), point.y()
                feat.setAttributes([i])
                feat.setGeometry(QgsPoint(x,y,0.0))

            prov1.addFeatures(feats)
            QgsProject.instance().addMapLayer(mem_layer)
            
            # Adicionando campos extra
            pr = mem_layer.dataProvider()
            pr.addAttributes([QgsField("projeto", QVariant.String),QgsField("alvo", QVariant.String),QgsField("ponto", QVariant.String),QgsField("amostra", QVariant.String),QgsField("duplicata", QVariant.String),QgsField("branco", QVariant.String),QgsField("padrao", QVariant.String),QgsField("reamostra", QVariant.String),QgsField("tipo", QVariant.String),QgsField("utme", QVariant.Double),QgsField("utmn", QVariant.Double),QgsField("elev", QVariant.Double),QgsField("datum", QVariant.String),QgsField("_zone",  QVariant.Int),QgsField("ns", QVariant.String),QgsField("descri", QVariant.String),QgsField("concentrad", QVariant.Bool),QgsField("fragmentos", QVariant.String),QgsField("matriz", QVariant.String),QgsField("comp_frag", QVariant.String),QgsField("compactaca", QVariant.String),QgsField("ambiente", QVariant.String),QgsField("resp", QVariant.String),QgsField("_data", QVariant.Date),QgsField("obs", QVariant.String),QgsField("coletado", QVariant.Bool),QgsField("tstp", QVariant.DateTime),QgsField("who", QVariant.String)])
            mem_layer.updateFields()
            # colocando valores default nas colunas fixas
            prov = mem_layer.dataProvider()
            datum_idx = mem_layer.fields().lookupField('datum')
            zone_idx = mem_layer.fields().lookupField('_zone')
            ns_idx = mem_layer.fields().lookupField('ns')
            utmn_idx = mem_layer.fields().lookupField('utmn')
            utme_idx = mem_layer.fields().lookupField('utme')
            elev_idx = mem_layer.fields().lookupField('elev')
            projeto_idx = mem_layer.fields().lookupField('projeto')
            alvo_idx = mem_layer.fields().lookupField('alvo')
            who_idx = mem_layer.fields().lookupField('who')
            ponto_idx = mem_layer.fields().lookupField('ponto')
            coletado_idx = mem_layer.fields().lookupField('coletado')
            atts = {datum_idx: datumlbl, zone_idx: zonevl, ns_idx: nslbl,utmn_idx: 0.0, utme_idx: 0.0, elev_idx: 0.0,projeto_idx: projetolbl, alvo_idx: alvolbl, who_idx: quem, coletado_idx: False}
            for line in mem_layer.getFeatures():
                prov.changeAttributeValues({line.id(): {ponto_idx: prefix+str(line.id()-1)}})

            for line in mem_layer.getFeatures():
                prov.changeAttributeValues({line.id(): atts})
            
            if self.dlg.checkBoxCsv.isChecked():
                parameter = {'INPUT': mem_layer,'TARGET_CRS': 'EPSG:4326','OUTPUT': 'memory:Reprojected'}
                result = processing.run('native:reprojectlayer', parameter)['OUTPUT']
                pr2 = result.dataProvider()
                for feature in result.getFeatures():
                    fields = result.fields()
                    attrs = {datum_idx: datumlbl, zone_idx: zonevl, ns_idx: nslbl,utmn_idx: feature.geometry().asPoint()[1], utme_idx: feature.geometry().asPoint()[0], elev_idx: 0.0,projeto_idx: projetolbl, alvo_idx: alvolbl, who_idx: quem, coletado_idx: False}
                    pr2.changeAttributeValues({feature.id(): attrs})
                    result.commitChanges()
                QgsVectorFileWriter.writeAsVectorFormat(result,os.path.join(csv,"dadossedcor.csv"),"utf-8",driverName = "CSV")

            QMessageBox.information(self.iface.mainWindow(),
                         'Pronto',
                         "Novo arquivo shape (e CSV*) ajustados e criados!")
            return
            
