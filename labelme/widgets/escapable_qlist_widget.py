from PyQt5 import QtWidgets
from PyQt5.QtCore import Qt


class EscapableQListWidget(QtWidgets.QListWidget):
    def keyPressEvent(self, event):
        super(EscapableQListWidget, self).keyPressEvent(event)
        if event.key() == Qt.Key_Escape:  # type: ignore[attr-defined]
            self.clearSelection()

    def itemDoubleClickedEvent(self, index):
        self.itemDoubleClicked.emit(self.model().itemFromIndex(index))
