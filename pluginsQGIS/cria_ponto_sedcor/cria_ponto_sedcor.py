# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QSettings, QTranslator, QCoreApplication, QVariant
from qgis.PyQt.QtGui import QIcon, QIntValidator, QDoubleValidator
from qgis.PyQt.QtWidgets import QAction, QMessageBox
from qgis.core import QgsProject,  QgsRasterLayer, QgsMapLayerType, QgsWkbTypes, QgsVectorLayer, QgsField
from .resources import *
from .cria_ponto_sedcor_dialog import CriaPontoSedcorDialog
import os.path
import numpy as np
from pysheds.grid import Grid
from osgeo import gdal
from shapely import geometry, ops
import fiona
import itertools
import pandas as pd
import geopandas as gpd
import processing

class CriaPontoSedcor:
    def __init__(self, iface):
        self.iface = iface
        self.plugin_dir = os.path.dirname(__file__)
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(
            self.plugin_dir,
            'i18n',
            'CriaPontoSedcor_{}.qm'.format(locale))

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)

        self.actions = []
        self.menu = self.tr(u'&GDataSystems Sedcor')
        self.first_start = None
    
    def tr(self, message):
        return QCoreApplication.translate('CriaPontoSedcor', message)

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
        icon_path = ':/plugins/cria_ponto_sedcor/icon.png'
        self.add_action(
            icon_path,
            text=self.tr(u'GDS-Cria Pontos Sedcor'),
            callback=self.run,
            parent=self.iface.mainWindow())

        self.first_start = True

    def unload(self):
        for action in self.actions:
            self.iface.removePluginMenu(
                self.tr(u'&GDS-Cria Ponto Sedcor'),
                action)
            self.iface.removeToolBarIcon(action)

    def run(self):
        if self.first_start == True:
            self.first_start = False
            self.dlg = CriaPontoSedcorDialog()
            
            onlyInt = QIntValidator()
            onlyDouble = QDoubleValidator()
            self.dlg.lineEditX.setText('0.0')
            self.dlg.lineEditX.setValidator(onlyDouble)
            self.dlg.lineEditY.setText('0.0')
            self.dlg.lineEditY.setValidator(onlyDouble)
            self.dlg.lineEditSnap.setText('10000')
            self.dlg.lineEditSnap.setValidator(onlyInt)
            self.dlg.lineEditAcc.setText('200')
            self.dlg.lineEditAcc.setValidator(onlyInt)
        
        self.dlg.show()
        result = self.dlg.exec_()
        if result:
            if self.dlg.lineEditY.text()=='' or self.dlg.lineEditX.text()=='' or self.dlg.lineEditSnap.text()=='' or self.dlg.lineEditAcc.text()=='' or self.dlg.lineEditProjeto.text()=='' or self.dlg.lineEditAlvo.text()=='' or self.dlg.lineEditQuem.text()=='' or self.dlg.lineEditPrefix.text()=='':
                QMessageBox.warning(self.iface.mainWindow(),
                         'Erro',
                         "Entrar todo os campos do formulário\nSaindo...")
                return
            layer = self.dlg.mQgsFileWidget.filePath()
            y = float(self.dlg.lineEditY.text())
            x = float(self.dlg.lineEditX.text())
            snapp= float(self.dlg.lineEditSnap.text())
            accc= float(self.dlg.lineEditAcc.text())
            datumlbl=self.dlg.comboBoxDatum.currentText()
            zonevl=int(self.dlg.comboBoxZona.currentText())
            nslbl=self.dlg.comboBoxNs.currentText()
            projetolbl=self.dlg.lineEditProjeto.text()
            alvolbl=self.dlg.lineEditAlvo.text()
            quem=self.dlg.lineEditQuem.text()
            prefix=self.dlg.lineEditPrefix.text()
            grid = Grid.from_raster(layer)
            dem = grid.read_raster(layer)
            pit_filled_dem = grid.fill_pits(dem)
            flooded_dem = grid.fill_depressions(pit_filled_dem)
            inflated_dem = grid.resolve_flats(flooded_dem)
            dirmap = (64, 128, 1, 2, 4, 8, 16, 32)
            fdir = grid.flowdir(inflated_dem, dirmap=dirmap)
            acc = grid.accumulation(fdir, dirmap=dirmap)
            x_snap, y_snap = grid.snap_to_mask(acc > snapp, (x,y))
            catch = grid.catchment(x=x_snap, y=y_snap, fdir=fdir, dirmap=dirmap,xytype='coordinate')
            grid.clip_to(catch)
            clipped_catch = grid.view(catch)
            branches = grid.extract_river_network(fdir, acc > accc, dirmap=dirmap)
            schema = {
                'geometry': 'LineString',
                'properties': {}
            }

            with fiona.open('rivers.shp', 'w',
                driver='ESRI Shapefile',
                crs=grid.crs.srs,
                schema=schema) as c:
                i = 0
                for branch in branches['features']:
                    rec = {}
                    rec['geometry'] = branch['geometry']
                    rec['properties'] = {}
                    rec['id'] = str(i)
                    c.write(rec)
                    i += 1
            layeriv = QgsVectorLayer('rivers.shp', 'Drenagem', "ogr")
            QgsProject.instance().addMapLayer(layeriv)
            df = gpd.read_file('rivers.shp')
            s = pd.Series(df.geometry.values, index=df.index).to_dict() 
            intersections = []
            for i in itertools.combinations(s, 2): 
                i1, i2 = i
                if s[i1].intersects(s[i2]): #If they intersect
                    intersections.append([s[i1].intersection(s[i2])]) 

            dfinter = gpd.GeoDataFrame(pd.DataFrame(data=intersections, columns=['geometry']), geometry='geometry', crs="EPSG:4326")
            dfinter.to_file('river_intersections.shp')
            ptsau0 = QgsVectorLayer('river_intersections.shp', 'Pontos', "ogr")
            parameters = {'INPUT': ptsau0,'OUTPUT': "temp.shp"}
            processing.run('native:deleteduplicategeometries', parameters)
            ptsau = QgsVectorLayer('temp.shp', 'Pontos', "ogr")
            ptsau.startEditing()
            id_idx = ptsau.fields().lookupField('FID')
            ptsau.renameAttribute(id_idx, 'id')
            ptsau.commitChanges()
            QgsProject.instance().addMapLayer(ptsau)
            pr = ptsau.dataProvider()
            pr.addAttributes([QgsField("projeto", QVariant.String),QgsField("alvo", QVariant.String),QgsField("ponto", QVariant.String),QgsField("amostra", QVariant.String),QgsField("duplicata", QVariant.String),QgsField("branco", QVariant.String),QgsField("padrao", QVariant.String),QgsField("reamostra", QVariant.String),QgsField("tipo", QVariant.String),QgsField("utme", QVariant.Double),QgsField("utmn", QVariant.Double),QgsField("elev", QVariant.Double),QgsField("datum", QVariant.String),QgsField("_zone",  QVariant.Int),QgsField("ns", QVariant.String),QgsField("descri", QVariant.String),QgsField("concentrad", QVariant.Bool),QgsField("fragmentos", QVariant.String),QgsField("matriz", QVariant.String),QgsField("comp_frag", QVariant.String),QgsField("compactaca", QVariant.String),QgsField("ambiente", QVariant.String),QgsField("resp", QVariant.String),QgsField("_data", QVariant.Date),QgsField("obs", QVariant.String),QgsField("coletado", QVariant.Bool),QgsField("tstp", QVariant.DateTime),QgsField("who", QVariant.String)])
            ptsau.updateFields()
            datum_idx = ptsau.fields().lookupField('datum')
            zone_idx = ptsau.fields().lookupField('_zone')
            ns_idx = ptsau.fields().lookupField('ns')
            utmn_idx = ptsau.fields().lookupField('utmn')
            utme_idx = ptsau.fields().lookupField('utme')
            elev_idx = ptsau.fields().lookupField('elev')
            projeto_idx = ptsau.fields().lookupField('projeto')
            alvo_idx = ptsau.fields().lookupField('alvo')
            who_idx = ptsau.fields().lookupField('who')
            ponto_idx = ptsau.fields().lookupField('ponto')
            coletado_idx = ptsau.fields().lookupField('coletado')
            atts = {datum_idx: datumlbl, zone_idx: zonevl, ns_idx: nslbl,utmn_idx: 0.0, utme_idx: 0.0, elev_idx: 0.0,projeto_idx: projetolbl, alvo_idx: alvolbl, who_idx: quem, coletado_idx: False}
            for line in ptsau.getFeatures():
                pr.changeAttributeValues({line.id(): {ponto_idx: prefix+str(line.id())}})

            for line in ptsau.getFeatures():
                pr.changeAttributeValues({line.id(): atts})
            
            QMessageBox.information(self.iface.mainWindow(),
                         'Pronto',
                         "Novo arquivo de Pontos criado!")
            return

