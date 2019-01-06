#!/usr/bin/env python

import helpers
import random
import sys
import unittest

class DelTest(helpers.MozzoniTest):
    def setUp(self):
        # Generate a random key for each test case to avoid potential
        # collisions
        self.key = random.randint(1, sys.maxint)

    def test_del(self):
        # No keys to remove, but should not error
        self.assertEqual(0,
                self.r.delete(self.key))

        # With a set keys the return should be the number of keys deleted
        self.assertTrue(
                self.r.set(self.key, 'yey'))
        self.assertEqual(1,
                self.r.delete(self.key))



if __name__ == '__main__':
    random.seed()
    unittest.main()
