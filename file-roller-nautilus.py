# File Roller Nautilus Extension
#
# Place me in ~/.local/share/nautilus-python/extensions/,
# ensure you have python-nautilus installed, restart Nautilus, and enjoy :)
#
# This script is released to the public domain.

from gi.repository import Nautilus, GObject
from subprocess import call


class FileRollerExtension(GObject.GObject, Nautilus.MenuProvider):

    def compress_with_file_roller(self, menu, files):
        paths = []
        for file in files:
            location = file.get_location()
            if location is None:
                continue
            path = location.get_path()
            if path:
                paths.append(path)

        if paths:
            call(['file-roller', '--add', *paths])

    def get_file_items(self, *args):
        files = args[-1]
        item = Nautilus.MenuItem(
            name='FileRollerCompress',
            label='Compress… (File Roller)',
            tip='Compress the selected files with File Roller'
        )
        item.connect('activate', self.compress_with_file_roller, files)

        return [item]
