# -*- coding: utf-8 -*-


# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load UploadSedcor class from file UploadSedcor.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .uploadsedcor import UploadSedcor
    return UploadSedcor(iface)
