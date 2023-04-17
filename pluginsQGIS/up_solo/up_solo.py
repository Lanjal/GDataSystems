# -*- coding: utf-8 -*-
"""
-------------------------------------------------------------------------------
   Copyright (C) 2023 GDataSystems <andre.costa@grupoge21.com>

   This file is a piece of free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
   You should have received a copy of the GNU Library General Public
   License along with this library; if not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------
"""
from qgis.PyQt.QtCore import QSettings, QTranslator, QCoreApplication
from qgis.PyQt.QtGui import QIcon
from qgis.gui import QgsFieldComboBox, QgsMapLayerComboBox
from qgis.core import QgsVectorLayerExporter, QgsCoordinateReferenceSystem, QgsProject, QgsMapLayerType, QgsWkbTypes
from qgis.PyQt.QtWidgets import QAction, QMessageBox, QMenu
from .resources import *
from .up_solo_dialog import UpSoloDialog
import os.path

class UpSolo:
    def __init__(self, iface):
        self.iface = iface
        self.plugin_dir = os.path.dirname(__file__)
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(
            self.plugin_dir,
            'i18n',
            'UpSolo_{}.qm'.format(locale))

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)
            QCoreApplication.installTranslator(self.translator)
    
        self.actions = []
        self.menu = self.tr(u'&GDataSystems Solo')
        self.first_start = None

    def tr(self, message):
        return QCoreApplication.translate('UpSolo', message)

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
        icon_path = ':/plugins/up_solo/icon.png'
        self.add_action(
            icon_path,
            text=self.tr(u'GDS-Upload Pontos Solo'),
            callback=self.run,
            parent=self.iface.mainWindow())
            
        self.first_start = True



    def unload(self):
        for action in self.actions:
            self.iface.removePluginMenu(
                self.tr(u'&GDS-Upload Pontos Solo'),
                action)
            self.iface.removeToolBarIcon(action)


    def run(self):
        if self.first_start == True:
            self.first_start = False
            self.dlg = UpSoloDialog()
            self.dlg.mMapLayerComboBox.setShowCrs(True)
            self.map_layers = QgsProject.instance().mapLayers().values()
            self.allow_list = [
                                lyr.id() for lyr in self.map_layers if lyr.type() == QgsMapLayerType.VectorLayer
                                and lyr.geometryType()== QgsWkbTypes.PointGeometry 
                                and lyr.name()=='soil2' 
                            ]
            self.except_list = [l for l in self.map_layers if l.id() not in self.allow_list]
            self.dlg.mMapLayerComboBox.setExceptedLayerList(self.except_list)

        self.dlg.show()
        result = self.dlg.exec_()
        if result:
            if self.dlg.lineEditHost.text()=='' or self.dlg.lineEditBd.text()=='' or self.dlg.lineEditUser.text()=='' or self.dlg.lineEditPass.text()=='':
                QMessageBox.warning(self.iface.mainWindow(),
                         'Erro',
                         "Entrar todo os campos do formulário\nSaindo...")
                return
            layer = self.dlg.mMapLayerComboBox.currentLayer()
            host = self.dlg.lineEditHost.text()
            db = self.dlg.lineEditBd.text()
            user = self.dlg.lineEditUser.text()
            pwd = self.dlg.lineEditPass.text()
            con_string = "dbname='"+db+"' host='"+host+"' port='5432' user='"+user+"' password='"+pwd+"' key=id type=POINT table=\"public\".\"soil2\" (geom)"
            err = QgsVectorLayerExporter.exportLayer(layer, con_string, 'postgres', layer.crs(), False)
            import psycopg2 as pg
            conn=pg.connect("host="+host+" dbname="+db+" user="+user+" password="+pwd)
            cur = conn.cursor()
            cur.execute("DELETE FROM soil")
            conn.commit()
            cur.execute("SELECT UpdateGeometrySRID('soil', 'geom', Find_SRID('public', 'soil2', 'geom'))")
            conn.commit()
            cur.execute("INSERT INTO soil(id,geom,projeto,alvo,ponto,utme,utmn,elev,coletado,who) SELECT id,geom,projeto,alvo,ponto,utme,utmn,elev,coletado,who FROM soil2")
            conn.commit()
            cur.execute("DROP TABLE soil2")
            conn.commit()
            cur.close()
            conn.close()
            QMessageBox.information(self.iface.mainWindow(),
                         'Pronto',
                         "Pontos Enviados!")
            return
