## This code from John Muschelli via
## https://www.r-bloggers.com/how-to-highlight-3d-brain-regions/
## Additional comments by Andy Wills

## CRAN packages already assumed to be installed.
library(rgl)        # 3D visualization using OpenGL
library(misc3d)     # Miscellaneous 3D plots
library(neurobase)  # Base package for 'neuroconductor' - helper functions for 'nifti' objects

## Check and install github R packages

## Automate identification of brain areas in MNI template
## http://www.gin.cnrs.fr/en/tools/aal/
if (!requireNamespace("aal")) {
  devtools::install_github("muschellij2/aal") 
} else {
  library(aal)
}

## Provide MNI template
if (!requireNamespace("MNITemplate")) {
  devtools::install_github("jfortin1/MNITemplate")
} else {
  library(MNITemplate)
}

## Generate image
img = aal_image()               # Load NIFTI image
template = readMNI(res = "2mm") # Load MNI template at 2mm resolution
cut <- 4500
dtemp <- dim(template)          # Dimensions of template

## All of the sections you can label
labs = aal_get_labels()

## Pick the region of the brain you would like to highlight
## in this case the hippocamus, bilaterally
hippocampus = labs$index[grep("Hippocampus", labs$name)]

## Create a mask for those regions
mask = remake_img(vec = img %in% hippocampus, img = img)

### this would be the ``activation'' or surface you want to render 
contour3d(template, x=1:dtemp[1], y=1:dtemp[2], z=1:dtemp[3], level = cut, alpha = 0.1, draw = TRUE)
contour3d(mask, level = c(0.5), alpha = c(0.5), add = TRUE, color=c("red") )
### add text
text3d(x=dtemp[1]/2, y=dtemp[2]/2, z = dtemp[3]*0.98, text="Top")
text3d(x=-0.98, y=dtemp[2]/2, z = dtemp[3]/2, text="Right")
rglwidget()
