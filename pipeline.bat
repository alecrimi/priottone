@echo off

:: split Multipage tif into several images
:: TO BE REPEATED FOR ALL TIFF series
:::magick convert input.tif %04d.tif not good as it split into several multipage
matlab -nodesktop -r stitching('input.tif'),quit


:: Add zero padding
Get-ChildItem *.* | Where{$_.basename -match "^\d+$"} | F
orEach{$NewName = "{0:d3}$($_.extension)" -f [int]$_.basename;rename-item $_.fullname $newname}

:::::::::::::::::::::::::TERA STITCHING PIPELINE:::::::::::::::::::::::::::::
:: 1] (OPTIONAL) Importing volume to the xml project file "xml_import"
terastitcher --import --volin="%CD%" --ref1=1 --ref2=-2 --ref3=3 --vxl1=0.8 --vxl2=0.8 --vxl3=1 --projout=xml_import

:: 2] Pairwise stacks displacement computation step. Needs a valid XML project file, which can (but does not need to) be produced by step 1]
terastitcher --displcompute --projin="%CD%/xml_import.xml" --projout=xml_displcomp --subvoldim=100

:: 3] Displacement projection
terastitcher --displproj --projin="%CD%/xml_displcomp.xml" --projout=xml_displproj

:: 4] Displacement thresholding
terastitcher --displthres --projin="%CD%/xml_displproj.xml" --projout=xml_displthres --threshold=0.7

:: 5] Optimal tiles placement
terastitcher --placetiles --projin="%CD%/xml_displthres.xml" --projout=xml_merging

:: Creating the directory where to put the stitching result
SET WORKINGDIR=%CD%
for %%* in (.) do SET DIRNAME=%%~n*
echo %DIRNAME%
cd..
mkdir %DIRNAME%_stitched
cd %DIRNAME%_stitched

:: 6] Merging and saving into a multiresolution representation (six resolutions are produced in this case)
terastitcher --merge --projin="%WORKINGDIR%/xml_merging.xml" --volout="%CD%/" --resolutions=012345
PAUSE

:::::::::::::::::::::::::::::END TERA STITCHER:::::::::::::

::Put together files into a stack
matlab -nodesktop -r create_stack,quit
