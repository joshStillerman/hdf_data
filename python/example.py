#!/usr/bin/python

from scipy import linspace
from scipy.special import jv
from h5_data import h5_data
import matplotlib.pyplot as plt
"""
  Define some variables for file level metadata
"""
file_name = 'Fig_3'
fig_description = 'Besel Functions J0, J1 and J2'
fig_source = 'Phys. Plasmas 17, 1234 2010'
comment = 'This is the way the ball bounces'
user_fullname = 'John Doe'

"""
  Draw the first trace.
"""
x = linspace(0, 20)
y0 = jv(0,x)
plt.plot(x,y0, '-b', label='J0')
x_units='s'
x_label='time (s)'
y0_units='m'
y0_label='height (m)'

"""
  Draw the 2nd trace.
"""
y1 = jv(1,x)
plt.plot(x, y1, '-g', label='J1')
y1_units='m'
y1_label='height (m)'

"""
  Draw the third trace.
"""
y2 = jv(2,x)
plt.plot(x, y2, '-r', label='J2')
y2_units='m'
y2_label='height (m)'

"""
  Add Labels and legend
"""
plt.title(fig_description)
plt.xlabel(x_label)
plt.ylabel(y0_label)
plt.legend(loc='upper right')
plt.show()
"""
  Create an hdf5 file to hold the data for this figure.

  Annotate it with the file-level metadata.
"""
hdf_file = h5_data("%s.hdf5"%(file_name,), 
                   fig_description = fig_description,
                   fig_source = fig_source,
                   comment = comment,
                   user_fullname = user_fullname)

"""
  Add the first data set, with its metadata.
"""
hdf_file.add_dataset('J0',
                     legend=None, plot_info='Blue Line', 
                     x_data=x, x_units=x_units, x_label=x_label, 
                     y_data=y0, y_units=y0_units, y_label=y0_label )

"""
  Add the second data set, with its metadata.
"""
hdf_file.add_dataset('J1',
                     legend=None, plot_info='Green Line', 
                     x_data=x, x_units=x_units, x_label=x_label, 
                     y_data=y1, y_units=y1_units, y_label=y1_label )

"""
  Add the third data set, with its metadata.
"""
hdf_file.add_dataset('J2',
                     legend=None, plot_info='Red Line', 
                     x_data=x, x_units=x_units, x_label=x_label, 
                     y_data=y2, y_units=y2_units, y_label=y2_label )

