#!/usr/bin/env python

import helpers
import random
import time
import sys

class SetTest(helpers.MozzoniTest):
    def setUp(self):
        # Generate a random key for each test case to avoid potential
        # collisions
        self.key = random.randint(1, sys.maxint)

    def test_set(self):
        self.assertTrue(self.r.set(self.key, 'value'))
        self.assertEqual(self.r.get(self.key), 'value')

    # Replace the given key
    def test_set_replace(self):
        self.assertTrue(self.r.set(self.key, 'value'))
        self.assertEqual(self.r.get(self.key), 'value')
        self.assertTrue(self.r.set(self.key, 'another'))
        self.assertEqual(self.r.get(self.key), 'another')

    def test_set_ex(self):
        self.assertTrue(
                self.r.set(self.key, 'value', ex=1)
                )
        self.assertEqual(self.r.get(self.key), 'value')
        time.sleep(2)
        self.assertFalse(self.r.get(self.key), 'value')

    def test_set_px(self):
        self.assertTrue(
                self.r.set(self.key, 'value', px=1500)
                )
        self.assertEqual(self.r.get(self.key), 'value')
        time.sleep(2)
        self.assertFalse(self.r.get(self.key), 'value')

    def test_set_nx(self):
        self.assertTrue(self.r.set(self.key, 'value'))
        self.assertEqual(self.r.get(self.key), 'value')

        # Ensure that we cannot set the key which already existsj
        self.assertEqual(None, self.r.set(self.key, 'another', nx=True))
        self.assertTrue(self.r.get(self.key), 'value')

    def test_set_xx(self):
        self.assertEqual(None, self.r.set(self.key, 'value', xx=True))
        self.assertEqual(None, self.r.get(self.key));

if __name__ == '__main__':
    random.seed()
    unittest.main()
