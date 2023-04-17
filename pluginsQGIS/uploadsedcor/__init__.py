# -*- coding: utf-8 -*-
"""
/***************************************************************************
 UploadSedcor
                                 A QGIS plugin
 Executa o upload dos pontos de amostragem de solo para uso com o aplicativo SoilTab.
 Generated by Plugin Builder: http://g-sherman.github.io/Qgis-Plugin-Builder/
                             -------------------
        begin                : 2023-03-20
        copyright            : (C) 2023 by André Costa
        email                : andre.costa@grupoge21.com
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
 This script initializes the plugin, making it known to QGIS.
"""


# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load UploadSedcor class from file UploadSedcor.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .uploadsedcor import UploadSedcor
    return UploadSedcor(iface)