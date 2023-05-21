# -*- coding: utf-8 -*-

# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load CriaPontoSedcor class from file CriaPontoSedcor.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .cria_ponto_sedcor import CriaPontoSedcor
    return CriaPontoSedcor(iface)
