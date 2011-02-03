\name{setStyleAction-methods}
\docType{methods}
\alias{setStyleAction}
\alias{setStyleAction-methods}
\alias{setStyleAction,workbook,character-method}
\title{Controlling application of cell styles when writing data to Excel}
\description{
Controls the application of cell styles when writing data to Excel.
}
\section{Methods}{
\describe{

\item{\code{signature(object = "workbook", type = "character")}}{
The argument \code{type} defines the style action to be used when writing data (\code{\link[=writeNamedRegion-methods]{writeNamedRegion}}, 
\code{\link[=writeWorksheet-methods]{writeWorksheet}}) to the specified workbook \code{object}. The following action types are
supported:\cr
\itemize{
\item \code{XLC$"STYLE_ACTION.XLCONNECT"}: This is the default. \code{data.frame} headers (if specified to be written) are colored in
in solid light grey (25 percent). character, numeric and logical vectors are written using Excel's "General" data format. Time/date vectors
(e.g. \code{Date} or \code{POSIXt}) are written with the "mm/dd/yyyy hh:mm:ss" data format. All cells are specified to wrap the text if necessary.
The corresponding custom cell styles are called \emph{XLConnect.Header}, \emph{XLConnect.General} and \emph{XLConnect.Date}.
\item \code{XLC$"STYLE_ACTION.PREDEFINED"}: This style action instructs \pkg{XLConnect} to use existing (predefined) cell styles when
writing headers and columns. This is useful in a template-based approach where an Excel template with predefined cell styles for headers and
columns is available. Normally, this would be used when the column dimensions (and potentially also the row dimensions) of the data tables 
are known up-front and as such a layout and corresponding cell styles can be pre-specified.\cr If a \code{data.frame} is written including 
its header, it is assumed that the Excel file being written to has predefined cell styles in the header row. Furthermore, the first row of data
is assumed to contain the cell styles to be replicated for any additional rows. As such, this style action may only be useful if the same column
cell style should be applied across all rows. Please refer to the available demos for some examples.
\item \code{XLC$"STYLE_ACTION.NAME_PREFIX"}: This style action instructs \pkg{XLConnect} to look for custom (named) cell styles with a specified prefix
when writing columns and headers. This style name prefix can be set via the method \code{\link[=setStyleNamePrefix-methods]{setStyleNamePrefix}}.\cr
For column headers, it first checks if there is a cell style named '\var{<STYLE_NAME_PREFIX>}.Header.\var{<COLUMN_NAME>}'. If there is no such cell style, 
it checks for a cell style named '\var{<STYLE_NAME_PREFIX>}.Header.\var{<COLUMN_INDEX>}'. Again, if there is no such cell style, it checks for 
'\var{<STYLE_NAME_PREFIX>}.Header' (no specific column discrimination). As a final resort, it just takes the workbook default cell style.\cr
For columns, \pkg{XLConnect} first checks the availability of a cell style named '\var{<STYLE_NAME_PREFIX>}.Column.\var{<COLUMN_NAME>}'. If there is no
such cell style, it checks for '\var{<STYLE_NAME_PREFIX>}.Column.\var{<COLUMN_INDEX>}'. If again there is no such cell style, it checks for
'\var{<STYLE_NAME_PREFIX>}.Column.\var{<COLUMN_DATA_TYPE>}' with \var{<COLUMN_DATA_TYPE>} being the corresponding data type from the set: 
\var{\{Numeric, String, Boolean, DateTime\}}. As a last resort, it would make use of the workbook's default cell style.
}
}
}}
\author{
Martin Studer\cr
Mirai Solutions GmbH \url{http://www.mirai-solutions.com}
}
\seealso{
\code{\linkS4class{workbook}}, \code{\linkS4class{cellstyle}}, \code{\link[=createCellStyle-methods]{createCellStyle}},
\code{\link[=writeNamedRegion-methods]{writeNamedRegion}}, \code{\link[=writeWorksheet-methods]{writeWorksheet}}, \code{\link[=setStyleNamePrefix-methods]{setStyleNamePrefix}}
}
\examples{
# Load workbook (create if not existing)
wb <- loadWorkbook("styleaction.xlsx", create = TRUE)

# Set style action to 'name prefix' 
setStyleAction(wb, XLC$"STYLE_ACTION.NAME_PREFIX")
# Set the name prefix to 'MyPersonalStyle'
setStyleNamePrefix(wb, "MyPersonalStyle")

# We now create a named cellstyle to be used for the header 
# (column names) of a data.frame
headerCellStyle <- createCellStyle(wb, name = "MyPersonalStyle.Header")
# Specify the cellstyle to use a solid foreground color
setFillPattern(headerCellStyle, fill = XLC$"FILL.SOLID_FOREGROUND")
# Specify the foreground color to be used
setFillForegroundColor(headerCellStyle, color = XLC$"COLOR.LIGHT_CORNFLOWER_BLUE")
# Specify a thick black bottom border
setBorder(headerCellStyle, side = "bottom", type = XLC$"BORDER.THICK", color = XLC$"COLOR.BLACK")

# We now create a named cellstyle to be used for the column named 'wt'
# (as you will see below, we will write the built-in data.frame 'mtcars')
wtColumnCellStyle <- createCellStyle(wb, name = "MyPersonalStyle.Column.wt")
# Specify the cellstyle to use a solid foreground color
setFillPattern(wtColumnCellStyle, fill = XLC$"FILL.SOLID_FOREGROUND")
# Specify the foreground color to be used
setFillForegroundColor(wtColumnCellStyle, color = XLC$"COLOR.LIGHT_ORANGE")

# We now create a named cellstyle to be used for the 3rd column in the data.frame
wtColumnCellStyle <- createCellStyle(wb, name = "MyPersonalStyle.Column.3")
# Specify the cellstyle to use a solid foreground color
setFillPattern(wtColumnCellStyle, fill = XLC$"FILL.SOLID_FOREGROUND")
# Specify the foreground color to be used
setFillForegroundColor(wtColumnCellStyle, color = XLC$"COLOR.LIME")

# Create a sheet named 'mtcars'
createSheet(wb, name = "mtcars")

# Create a named region called 'mtcars' referring to the sheet called 'mtcars'
createName(wb, name = "mtcars", formula = "mtcars!$A$1")

# Write built-in data set 'mtcars' to the above defined named region.
# The style action 'name prefix' will be used when writing the data
# as defined above.
writeNamedRegion(wb, mtcars, name = "mtcars")

# Save workbook (this actually writes the file to disk)
saveWorkbook(wb)
}
\keyword{methods}
\keyword{utilities}