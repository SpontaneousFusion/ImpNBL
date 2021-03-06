# This is the main R file for ImpNBL library
#

###
##
#
#
#
#     types:
#     1 - Main NBL
#     2 - NaI NBL
#     3 - HPGe NBL
#
##
###

file.path="~/Dropbox/Bayesiansk statistikprojekt/Data/AUTOMORC_setups/setup1"
#
# NBL.type=1

fReadNBL_old=function(file.path,NBL.type=1)
{

  file.Main=paste0(file.path,".nbl")
  file.NaI=paste0(file.path,".nbl.NaI")
  file.HPGE=paste0(file.path,".nbl.HPGe")


  ##
  # reading the cordinates from the main file
  ##
  # file size in bytes bytes
  close(file.connection)
  n = file.info(file.Main)$size/(304 * 2)
  file.connection = file(file.Main, "rb")
  coords <- matrix(nrow = n, ncol=2)
  start.times=matrix(nrow=n,ncol=1)
  spectra.Main=matrix(nrow=n,ncol=256)
  main.nbl.data=matrix(nrow=n,ncol=9)

  # fix.offset=c()
  i=1
  for(i in 1:n)
  {

    readBin(file.connection,what= integer(), endian="little",size=2,n=1) # HeaderSize
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) # numeber of Channels
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) # Data Type
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) # Header Type

    readBin(file.connection,what= integer(), endian="little",size=4,n=1) #Start Day
    start.times[i,1]=readBin(file.connection,what= integer(), endian="little",size=4,n=1) # Start Time
    readBin(file.connection,what= integer(), endian="little",size=4,n=1) # Real Time
    readBin(file.connection,what= integer(), endian="little",size=4,n=1) # Live Time


    main.nbl.data[i,1]=readBin(file.connection,what= integer(), endian="little",size=2,n= 1,signed=T) # Spectrum Number
    main.nbl.data[i,2]=readBin(file.connection,what= integer(), endian="little",size=2,n= 1) # Buffer Number

    main.nbl.data[i,3]=readBin(file.connection,what= integer(), endian="little",size=4,n=1) # Doserate

    coords[i, 2]= (180 / pi ) * readBin(file.connection,what= double(), endian="little",n=1)
    # coords[i, 2]
    coords[i, 1]= (180 / pi ) * readBin(file.connection,what= double(), endian="little",n=1)
    # coords[i, 1]

    main.nbl.data[i,4]=readBin(file.connection,what= double(), endian="little",n=1) # Altitude
    main.nbl.data[i,5]=readBin(file.connection,what= integer(), endian="little",size=4,n=1,signed=T) # Speed E single
    main.nbl.data[i,6]=readBin(file.connection,what= integer(), endian="little",size=4,n=1) # Speed N single
    main.nbl.data[i,7]=readBin(file.connection,what= integer(), endian="little",size=4,n=1) # Speed Up  single
    readBin(file.connection,what= integer(), endian="little",size=4,n=1) #PDOP SV6 single
    main.nbl.data[i,8]=readBin(file.connection,what= integer(), endian="little",size=4,n=1) #Fix offset long
    main.nbl.data[i,9]=readBin(file.connection,what= integer(), endian="little",size=2,n=1) #Nr Satellites long
    readBin(file.connection,what= character(), endian="little",size=1,n=4) #Info strings
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) #Source
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) #Age
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) #NaI Stored
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) #GR820 Stored
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) #Ground Height
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) #Geoid Height
    readBin(file.connection,what= integer(), endian="little",size=2,n=1) #Height above ground

    spectra.Main[i,]=readBin(file.connection,what= integer(), endian="little",size=2,n=256)
  spectra.Main[i,]
    }
  close(file.connection)
# fix.offset
main.nbl.data

  spectra.HPGe = matrix( nrow = n, ncol = 2048)
  livetime.HPGe = matrix( nrow = n, ncol = 1)
  realtime.HPGe = matrix( nrow = n, ncol = 1)
  file.connection = file(file.HPGE, "rb")
  for(i in 1:n)
  {
    realtime.HPGe[i]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    livetime.HPGe[i]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    spectra.HPGe[i,]=readBin(file.conncecortion,what= integer(), endian="little",size=2,n=2048)
  }
  close(file.connection)



  spectra.NaI = matrix( nrow = n, ncol = 256)
  livetime.NaI = matrix( nrow = n, ncol = 1)
  realtime.NaI = matrix( nrow = n, ncol = 1)
  file.connection = file(file.NaI, "rb")
  for(i in 1:n)
  {
    realtime.NaI[i]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    livetime.NaI[i]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    spectra.NaI[i,]=readBin(file.connection,what= integer(), endian="little",size=2,n=256)
  }
  close(file.connection)






  if(NBL.type==1)
  {
    output=data.frame(coords,spectra.Main)
  }

  if(NBL.type==2)
  {
    output=data.frame(coords,spectra.NaI)
  }

  if(NBL.type==3)
  {
    output=data.frame(coords,spectra.HPGe)
  }



  return(output)
}
