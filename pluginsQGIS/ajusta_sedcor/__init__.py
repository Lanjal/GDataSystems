# -*- coding: utf-8 -*-
"""
/***************************************************************************
 AjustaSedcor
                                 A QGIS plugin
 Adiciona campos aos pontod de coleta
 Generated by Plugin Builder: http://g-sherman.github.io/Qgis-Plugin-Builder/
                             -------------------
        begin                : 2023-03-27
        copyright            : (C) 2023 by André Costa
        email                : andre.costa@grupoge21.com
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the is licensed under the BSD 3-Clause "New" or *
 *   "Revised" License.
 *                                                                         *
 ***************************************************************************/
 This script initializes the plugin, making it known to QGIS.
"""


# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load AjustaSedcor class from file AjustaSedcor.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .ajusta_sedcor import AjustaSedcor
    return AjustaSedcor(iface)