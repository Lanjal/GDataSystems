# -*- coding: utf-8 -*-
# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load GridBuilder class from file GridBuilder.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .grid_builder import GridBuilder
    return GridBuilder(iface)
