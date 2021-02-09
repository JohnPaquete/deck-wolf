import unittest
import src.viewtilities as util

class TestViewtilities(unittest.TestCase):
    def test_legality(self):
        self.assertEqual("Legal", util.legality("legal"))
        self.assertEqual("Not Legal", util.legality("not_legal"))
        self.assertEqual("Restricted", util.legality("restricted"))
        self.assertEqual("Banned", util.legality("banned"))
        self.assertEqual("NO ENTRY", util.legality(None))
        self.assertEqual("NO ENTRY", util.legality(15))
        self.assertEqual("NO ENTRY", util.legality("Error"))
    
    def test_legality_bg(self):
        self.assertEqual("table-success", util.legality_bg("legal"))
        self.assertEqual("table-secondary", util.legality_bg("not_legal"))
        self.assertEqual("table-warning", util.legality_bg("restricted"))
        self.assertEqual("table-danger", util.legality_bg("banned"))
        self.assertEqual(None, util.legality_bg(None))
        self.assertEqual(None, util.legality_bg(15))
        self.assertEqual(None, util.legality_bg("Error"))
    
    def test_rarity(self):
        self.assertEqual("Common", util.rarity("common"))
        self.assertEqual("Uncommon", util.rarity("uncommon"))
        self.assertEqual("Rare", util.rarity("rare"))
        self.assertEqual("Mythic", util.rarity("mythic"))
        self.assertEqual("NO ENTRY", util.rarity(None))
        self.assertEqual("NO ENTRY", util.rarity(15))
        self.assertEqual("NO ENTRY", util.rarity("Error"))
    
    def test_curency(self):
        self.assertEqual("$0.12", util.currency(0.12, "$"))
        self.assertEqual("$0.12", util.currency("0.12", "$"))
        self.assertEqual("0.12", util.currency("0.12", None))
        self.assertEqual("--", util.currency(None, "$"))
        self.assertEqual("0.12", util.currency(0.12, None))