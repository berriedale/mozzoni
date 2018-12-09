#!/usr/bin/env python

import helpers

class SetTest(helpers.MozzoniTest):
    def test_set(self):
        self.assertTrue(self.r.set('key', 'value'))
        self.assertEqual(self.r.get('key'), 'value')


if __name__ == '__main__':
    unittest.main()
