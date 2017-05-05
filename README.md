Tools to export machine-readable datasets from IDL/Python/MATLAB and πScope

S. Shiraiwa, M. Greenwald, J.A. Stillerman, G.M. Wallace, M.R. London, and J. Thomas

Plasma Science Fusion Center, MIT
=================================

IAEA TM 20171

Abstract
========

This paper presents the efforts at PSFC to comply with a new directive from the White House Office of Science and Technology Policy, which requires that all publications supported by federal funding agencies (e.g. Department of Energy Office of Science, National Science Foundation) include machine-readable datasets for figures and tables. The memorandum \[1\] includes a specific language saying that the data must be “stored and publicly accessible to search, retrieve, and analyze”, which disfavors the use of proprietary formats such as an IDL save set and encourages the use of more openly available data formats. The manual effort required for producing a well documented, and therefore potentially useful, data set is not trivial. At PSFC, we defined a standard schema for data and metadata to comply the new open data requirement along with procedures in several commonly used scientific languages (IDL, MATLAB, Python)for generating an HDF5 format output for our common data analysis environments.

πScope is a python data analysis environment, which allows a user to generate publication quality graphics seamlessly from MDSplus data system \[2\]. It allows a user to edit, annotate, and save Matplotlib figures. All plot commands inπScope accept a keyword to define a graphics metadata at plotting. It also equipped with a newly added interactive interface to HDF5 metadata export, which collects metadata from an existing figure and allows user to edit them. As for MATLAB , we developed a fully automated MATLAB script, which extracts the data and metadata from a .fig file and exports it into HDF5. This script requires no additional user input, resulting in quick and convenient data file generation, but is less flexible in terms of controlling the variety of metadata in the file.

The PSFC library must now manage and distribute the collection of files associated with each manuscript. A web based document submission and distribution system has been developed for this. Authors provide additional files and metadata with their manuscript, and these are in turn archived with the manuscript in Harvard Dataverse, MIT DSpace and DoE Pages.

\[1\] J.P. Holdren. \`\`Increasing Access to the Results of Federally Funded Scientific Research.'' Feb.

22, 2013, https://obamawhitehouse.archives.gov/blog/2016/02/22/increasing-access-resultsfederally-funded-science

\[2\] S. Shiraiwa et. al., Fusion Engineering and Design 112, 835-838 (2016) IAEA TM 20172

New federal directive requires archival datasets for all published figures

• Directive from White House Office of Science and Technology Policy (OSTP) to federal funding agencies requires storage and access of digital data from all non-classified sponsored research

• Department of Energy has developed a Public Access Plan, as have other federal agencies such as NSF

IAEA TM 20173

https://www.whitehouse.gov/sites/default/files/microsites/ostp/ostp\_public\_a ccess\_memo\_2013.pdf

IAEA TM 20174

http://www.energy.gov/sites/prod/files/2014/08/f 18/DOE\_Public\_Access%20Plan\_FINAL.pdf

IAEA TM 20175

PSFC-wide guideline for data management (Metadata/HDF5 export)
==============================================================

● While the directive is the vague in terms of the level of details attached to the data archive to make the archive truly useful, we proactively define the set of metadata to be stored together and established PSFC-wide guideline for our future publications.

– Tools (script/modules) are developed for three popular data analysis languages (IDL/Python/MATLAB) and πScope integrated data analysis platform

– PSFC document eco-system was expanded to enforce our future publication to meet DOE data management requirements

● Figures are represented as groups of 1D, 2D, 3D Arrays in HDF5 (terms in ***italics*** are HDF5 entities) –One HDF5 ***file*** per figure

–Multiple HDF5 ***groups*** (or actually ***subgroups*** of the ***root*** ***grou****p***) are used to represent distinguishable elements in figure.

–Array data itself is stored as HDF5 ***datasets***

*o **Dataset*** names – describe the x, y, z in each data group

–Metadata, as listed below, is represented as HDF5 ***attributes*** attached to ***group*** (***root*** ***group*** or otherwise) or to a ***dataset***

–We define metadata at file(figure), group and data levels (as shown below)

IAEA TM 20176

HDF5 file format chosen for data archive format at MIT PSFC
===========================================================

• HDF5 file format is an open, machine readable, cross platform standard

• HDF5 supported by many commonly used computing environments (MATLAB, IDL, Python, FORTRAN, C…)

• Format allows storage of data (e.g. x, y points) and attributes (*e.g.* labels, colors) within a single file

• Manually creating HDF5 file for each figure will change established user workflow dramatically

IAEA TM 20177

File Level Metadata
===================

● **Y(X)**

– file = name of hdf5 file (without extension) text that should include the figure number/identifier

– fig\_description = could be the figure caption or a short form of the caption – fig\_source = string that identifies the manuscript or publication

– date = Date/time written

– user\_fullname = Writer’s full name – user\_id = Writer’s account name

– n\_groups = Number of data groups

– comment = (attribute of root group) string, anything you want to say, including description of plot type ( e.g. polar, rectilinear)

IAEA TM 20178

Dataset Metadata
================

● **For** **each** **dataset** **or** **data** **group**

– group\_name = Data set (string, could be from plot legend or similar text) – plot\_graphics = plotting info (optional info on color, symbol, line type)

IAEA TM 20179

“Data” Level Metadata
=====================

●**Dataset**●**Dataset**

–**x** **=** **x** **data** **values**–**y** **=** **y** **data** **values**

IDL tools for Metadata/HDF5 export
==================================

IAEA TM 201711

IDL Tools For Writing HDF5 File Of This Type
============================================

● Software, written in the IDL language are available to help users create files conforming to the standards we’ve defined

● hdf5\_new.pro contains 2 procedures.

– hdf5\_new is called to create a new data file and load the file-level metadata. – hdf5\_add adds a data group to an existing data file

● hdf5\_test.pro is a simple example of the use of these two procedures

● Procedures have calling signatures very similar to the intrinsic calls which generate the graphics. This makes it very easy to add file creation to figure generation routines.

Software available on request – see M. Greenwald (g@psfc.mit.edu)
=================================================================

IAEA TM 201712

Python module for Metadata/HDF5 export
======================================

IAEA TM 201713

h5\_data module for python

• Python module to provide a convenient interface for – Creating HDF5 file

– Recording metadata (dataset) as a user create a plot

IAEA TM 20171414

Example
=======

Example (cont…)
===============

**\#** **Draw** **thethird** **curve** y2 = jv(2,x)

plot(x, y2, '-r', label='J2') y2\_units='m’ y2\_label='height (m)’ title(fig\_description) xlabel(x\_label) ylabel(y0\_label)

**\#** **Add** **a** **legend** legend(loc='upper right')

**\#add** **the** **third** **curve** **to** **the** **file** **hdf\_file.add\_dataset('J2',** **x,y2,** **legend=None,** **plot\_info='RedLine',**

**x\_units=x\_units,** **x\_label=x\_label,x\_datatype='float',** **y\_units=y2\_units,** **y\_label=y2\_label,y\_datatype='float')**

IAEA TM 20171616

Contents of HDF5
================

Metadata/HDF5 export support in MATLAB
======================================

IAEA TM 201718

What is the convenient way for Metadata/HDF5 export in MATLAB?
==============================================================

• MATLAB \*.fig file contains all the data and metadata to reproduce the figure

• Users often save a \*.fig file so it can be modified later (*e.g.* change symbol shapes)

• If you have access to a \*.fig file, it would be much more convenient to export the \*.fig file to HDF5 rather than access all the raw data from storage, re-analyze it, then manually save each data trace to HDF5 file after the fact

IAEA TM 201719

A script to converts \*.fig file to HDF5 is developed
=====================================================

• Simple, easy to operate script (export\_fig.m) • Less than 1 second to process most figures

• No need to find your old code, re-run analysis, etc. Just locate the \*.fig file and go

• The script creates HDF5 file without any user input

• Example usage for file ‘example1.fig’: &gt;&gt; export\_fig(‘example1’)

• Stores attributes: line style, line width, color, marker shape, legend name, x-label, y-label, z-label, title

IAEA TM 201720

Example: simple figure
======================

HDF5 example9.h5 Group '/'

<img src="media/image6.png" width="594" height="445" />Group '/Plot1' Attributes:

'XLabel1': '\\theta \[rad\]' 'YLabel1': 'Voltage \[V\]'

Group '/Plot1/Data1' Attributes:

'StructPath': 's.hgS\_070000.children(1).children(1).properties' 'Color \[r g b\]': 0.000000 0.447000 0.741000

Dataset 'XData' Size: 1x100 MaxSize: 1x100

Datatype: H5T\_IEEE\_F64LE (double) ChunkSize: \[\]

Filters: none FillValue: 0.000000

Dataset 'YData' Size: 1x100 MaxSize: 1x100

Datatype: H5T\_IEEE\_F64LE (double) ChunkSize: \[\]

Filters: none
=============

FillValue: 0.000000IAEA TM 201721

Example: 2-D color plot
=======================

Metadata/HDF5 export from πScope
================================

IAEA TM 201723

πScope is a python based data analysis environment

• Data analysis platform for python, equipped with editor, data browser, figure, and python shell

• Graphics is based on Matplotlib + OpenGL

• Integrated MDSplus data viewer • Open source (GNUv3)

– (wiki) http://piscope.psfc.mit.edu

– (download) https://github.com/piScope/piScope

• As being Open Source, we have a full access to the program to realize the most convenient metadata/HDF5 support

IAEA TM 201724

Graphics are managed by an object tree, and tree objects can store metadata

• Objects are accessible from a TreeBrowser • Each object can have metadata

• A user can edit metadata from python shell

Objects’ Metadata
=================

Access to metadata from python shell
====================================

IAEA TM 201725

A user can attach metadata to plot objects using special keywords
=================================================================

• Special keywords metadata, \[x, y, z, c\]metadata

– metadata is used to attach full variety of metadata or “longname” of plot. – \[x, y, z, c\]metadata is used to set “longname” of axis.

(example)

plot(np.arange(30), metadata = {'longname':'plot name', 'xdata':{'longname': 'xdata name', 'unit': '\[s\]'}, 'ydata':{'longname': 'ydata name', 'unit': '\[V\]'}})

plot(np.arange(30), metadata = 'metadata', xmetadata='xdata')

• Allows a user to set metadata when issuing plot commands

• Implemented using python decorator, so that all plot commands in πScope accept the same keywords.

IAEA TM 201726

Powerful GUI tool to support exporting HDF file from πScope figure
==================================================================

<img src="media/image12.png" width="402" height="523" />• In order to export a HDF data, a user simply select “Export -&gt; HDF file…”

– By default, numerical data + a subset of graphics properties are stored.

– User can select which property to store

– User can edit metadata associated to the data

• Allows a user to export a HDF file following PSFC guideline from any existing figure file.

IAEA TM 201727

Express Metadata/HDF5 export from MDSplus data to metadata
==========================================================

IAEA TM 201728

PSFC Document EcoSystem
=======================

IAEA TM 201729

PSFC Document EcoSystem was expanded to meet DOE data management requirements
=============================================================================

D
=

A
=

**Phase** **I** Author Submission

Report Submission Flow Chart

**via** **Automated,** **Self-Service,** **Web** **Interface**
