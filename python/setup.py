#!/usr/bin/env python

from setuptools import setup, Extension
version='0.1'
setup(name='h5_data',
      version=version,
      description='MIT/PSFC Data standard published figures',
      long_description = """
         US Dept. of Energy now requires that all publications 
         done under DOE funding include readable data for each
         figure.

         This module creates a simple standard HDF5 file to represent
         the data for a figure.
      """,
      author='Josh Stillerman, Martin Greenwald',
      author_email='jas@psfc.mit.edu',
      url='http://www.psfc.mit.edu/',
      package_dir = {'h5_data':'.',},
      packages = ['h5_data',],
#      package_data = {'MDSplus':'*'},
      package_data = {'':['example.py',]},
      platforms = ('Any',),
      classifiers = [ 'Development Status :: 4 - Beta',
      'Programming Language :: Python',
      'Intended Audience :: Science/Research',
      'Environment :: Console',
      'Topic :: Scientific/Engineering',
      ],
      keywords = ('physics','data','Department of Energy'),
      install_requires=["h5py", "scipy", "matplotlib"],
      zip_safe = False,
     )
