# -*- coding: utf-8 -*-

# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load AjustaSedcor class from file AjustaSedcor.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .ajusta_sedcor import AjustaSedcor
    return AjustaSedcor(iface)
