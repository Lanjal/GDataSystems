# -*- coding: utf-8 -*-
# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load UpSolo class from file UpSolo.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .up_solo import UpSolo
    return UpSolo(iface)
