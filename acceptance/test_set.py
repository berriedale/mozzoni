#!/usr/bin/env python

import helpers
import time

class SetTest(helpers.MozzoniTest):
    def test_set(self):
        self.assertTrue(self.r.set('key', 'value'))
        self.assertEqual(self.r.get('key'), 'value')

    def test_set_ex(self):
        self.assertTrue(
                self.r.set('keyex', 'value', ex=1)
                )
        self.assertEqual(self.r.get('keyex'), 'value')
        time.sleep(2)
        self.assertFalse(self.r.get('keyex'), 'value')

if __name__ == '__main__':
    unittest.main()
