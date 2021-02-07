import unittest
import src.viewtilities as util

class TestViewtilities(unittest.TestCase):
    def test_legality(self):
        self.assertEqual("Legal", util.legality("legal"))