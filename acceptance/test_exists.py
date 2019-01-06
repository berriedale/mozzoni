#!/usr/bin/env python

import helpers
import random
import sys
import unittest

class ExistsTest(helpers.MozzoniTest):
    def setUp(self):
        # Generate a random key for each test case to avoid potential
        # collisions
        self.key = random.randint(1, sys.maxint)

    def test_exists(self):
        self.assertFalse(self.r.exists(self.key))

    def test_exists_with_key(self):
        self.assertTrue(
                self.r.set(self.key, 'yey'))
        self.assertTrue(
                self.r.exists(self.key))

    def test_exists_multiple(self):
        another_key = random.randint(1, sys.maxint)
        self.assertEqual(0,
                self.r.exists(self.key, another_key))

        self.assertTrue(
                self.r.set(self.key, 'yey'))

        # Ensure that once a key has been set we get the integer value back
        self.assertEqual(1,
                self.r.exists(self.key, another_key))

        self.assertTrue(
                self.r.set(another_key, 'yey'))

        # Ensure that multiple keys returns the number of values we expect
        self.assertEqual(2,
                self.r.exists(self.key, another_key))


if __name__ == '__main__':
    random.seed()
    unittest.main()
