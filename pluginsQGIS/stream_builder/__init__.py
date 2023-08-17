# -*- coding: utf-8 -*-
# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load StreamBuilder class from file StreamBuilder.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .stream_builder import StreamBuilder
    return StreamBuilder(iface)
