# -*- coding: utf-8 -*-



# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load AjustaSolo class from file AjustaSolo.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .ajusta_solo import AjustaSolo
    return AjustaSolo(iface)
