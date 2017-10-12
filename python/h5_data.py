import h5py
from getpass import getuser
from datetime import datetime

class h5_data():
    """
   class h5_data - used to create hdf5 files to go with figures in publications

    h5_data objects can be used for both creation or modification of these HDF5 files.

    from h5_data import h5_data
    h5 = h5_data('exsiting-file-to-be-extended')

    or

    h5 = h5_data('file-to-be-created', file-level-metadata)

    to add data
        
    h5.add_dataset(name, x, y, ...)


    """

    def __init__(self, filename, user_fullname=None, fig_description=None, fig_source=None, comment=None ):
        """
	Create an h5_data object.

        If the file exists, the file level metadata will be updated with any specified arguments.
        If the file does not exist, it will be created with all specified file level metadata.

        @param file-name: Name of the file to create or open
        @type file-name: str
        @param user_fullname: Optional user_fullname, name of the user creating this file
        @type user_fullname: str
        @param fig_description: Optional description of this figure.
        @type fig_description: str
        @param source: Optional source for this file (e.g. 'Phys. Plasmas 17, 1234 2010')
        @type sourcet: str
        @param comment: Optional file level comment for this figure
        @type comment: str
        """

        self.filename = filename 

        try:
            self.fd = h5py.File(filename, 'r+')
            self.root = self.fd['root']
        except:
            try:
                self.fd = h5py.File(filename, 'w')
                self.root = self.fd.create_group('root')
                self.root.attrs['n_groups'] = 0
                self.root.attrs['user_fullname'] = user_fullname or ''
                self.root.attrs['user_id'] = getuser()
                self.root.attrs['date'] = str(datetime.now())
                self.root.attrs['fig_description'] = fig_description or ''
                self.root.attrs['fig_source'] = fig_source or ''
                self.root.attrs['comment'] = comment or ''
            except Exception,e:
                raise(e, "error opening hdf5 file for write /%s/"%(filename,))

            
    def add_dataset(self, name, legend=None, plot_info=None, 
                    x_data=None, x_units=None, x_label=None,
                    y_data=None, y_units=None, y_label=None, 
                    z_data=None, z_units=None, z_label=None, ) :

        """
        Add a data_set (trace) to an existing Figure file

        @param name: Name of this data set
        @type name: str
        @param legend: Optional legend for this trace
        @type legend: str
        @param plot_info: Optional information on plot representation (e.g. 'blue squares').
        @type plot_info: str

        @param x_data: Data for the X axis
        @type x_data: numeric
        @param x_units: Optional units for X axis
        @type x_units: str
        @param x_label: Optional label for X axis
        @type x_label: str

        @param y_data: Data for the Y axis
        @type y_data: numeric
        @param y_units: Optional units for Y axis
        @type y_units: str
        @param y_label: Optional label for Y axis
        @type y_label: str

        @param z_data: Data for the Z axis
        @type z_data: numeric
        @param z_units: Optional units for Z axis
        @type z_units: str
        @param z_label: Optional label for Z axis
        @type z_label: str
        """

        try:
            del self.root[name]
        except:
            self.root.attrs['n_groups'] += 1
        ds = self.root.create_group(name)
        ds.attrs['group 1 plotting information'] = plot_info
        ds.attrs['legend'] = legend or name
        if x_data is not None:
            try:
                del ds['x_values']
            except:
                pass
            x_values = ds.create_dataset('x_values', data=x_data)
            x_values.attrs['units'] = x_units or ''
            x_values.attrs['axis label'] = x_label or ''
            x_values.attrs['data type'] = str(y_data.dtype)
            x_values.attrs['nx'] = len(x_data)

        if y_data is not None:
            try:
                del ds['y_values']
            except:
                pass
            y_values = ds.create_dataset('y_values', data=y_data)
            y_values.attrs['units'] = y_units or ''
            y_values.attrs['axis label'] = y_label or ''
            y_values.attrs['data type'] = str(y_data.dtype)
            y_values.attrs['ny'] = len(y_data)

        if z_data is not None:
            try:
                del ds['z_values']
            except:
                pass
            z_values = ds.create_dataset('z_values', data=z_data)
            z_values.attrs['units'] = z_units or ''
            z_values.attrs['axis label'] = z_label or ''
            z_values.attrs['data type'] = str(y_data.dtype)
            z_values.attrs['nz'] = len(z_data)
