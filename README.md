# ImpNBL
This package ImpNBL is used to obtain data from NBL files created using Nugget software.

It is possible to get either the spectra stored in main, NaI or HPGe NBL files. To select which spectra one wishes to obtain, the second argument should be passed reflecting the respective choice:
- main NBL file - 1,
- NaI NBL file - 2,
- HPGe NBL file - 3.

Number of channels in corresponding NBL files are 256, 256 and 2048.

The function returns a matrix of values. The number of rows in the matrix is set to the number of observations in the NBL files. The first two columns are WGS84 coordinates of the location where the spectra was collected.

The file path should omit any file extensions (*.NBL,*.NBL.NaI,etc.), as they are managed under the hood.

Example code:
`path="~/SomeDirectory/SomeFile"`
`NBL.type=1 #selecting main NBL file`
`fReadNBL(path,NBL.type)`
