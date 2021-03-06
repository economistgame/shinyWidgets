
# ------------------------------------------------------------------------ #
#
# Descriptif : Awesome Radio
#        via : http://flatlogic.github.io/awesome-bootstrap-checkbox/demo/
#
#
# Auteurs : Victor PERRIER
#
# Date creation : 23/08/2016
# Date modification : 23/08/2016
#
# Version 1.0
#
# ------------------------------------------------------------------------ #



# Generate one radio
radioAlone <- function(id, name, label, value, selected = FALSE, status = "primary", inline = FALSE, checkbox = FALSE) {
  status <- match.arg(arg = status, choices = c("primary", "success", "info", "warning", "danger"))
  if (!checkbox) {
    divClass <- paste0("radiobs radio-bs radio-bs-", status)
  } else {
    divClass <- paste0("checkboxbs checkbox-bs checkbox-bs-circle checkbox-bs-", status)
  }
  if (inline)
    # if (!checkbox)
      divClass <- paste(divClass, "radio-inline radio-bs-inline")
    # else
    #   divClass <- paste(divClass, "checkbox-inline checkbox-bs-inline")
  inputTag <- tags$input(name=name, id=id, value=value, type="radio")
  if (selected)
    inputTag$attribs$checked <- "checked"
  tags$div(class=divClass, inputTag, tags$label(`for`=id, label))
}


# Generate several radios
generateAwesomeRadio <- function(inputId, choices, selected, inline, status, checkbox) {
  tags$div(
    class="shiny-options-group", #style = "margin-top: -10px;",
    lapply(
      X = seq_along(choices),
      FUN = function(x) {
        selec <- choices[x] %in% selected[[1]]
        radioAlone(
          id = paste0(inputId, x), name = inputId, inline = inline,
          label = names(choices)[x], value = choices[x], selected = selec, status = status, checkbox = checkbox
        )
      }
    )
  )
}





#' @title Awesome Radio Buttons Input Control
#'
#' @description
#' Create a set of prettier radio buttons used to select an item from a list.
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param label Input label.
#' @param choices List of values to select from (if elements of the list are named then that name rather than the value is displayed to the user)
#' @param selected	The initially selected value
#' @param status Color of the buttons, a valid Bootstrap status : default, primary, info, success, warning, danger.
#' @param inline If TRUE, render the choices inline (i.e. horizontally)
#' @param checkbox Logical, render radio like checkboxes
#' @return A set of radio buttons that can be added to a UI definition.
#'
#' @seealso \code{\link{updateAwesomeRadio}}
#'
#' @importFrom shiny restoreInput
#' @importFrom htmltools tags
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   br(),
#'   awesomeRadio(
#'     inputId = "id1", label = "Make a choice:",
#'     choices = c("graphics", "ggplot2")
#'   ),
#'   verbatimTextOutput(outputId = "res1"),
#'   br(),
#'   awesomeRadio(
#'     inputId = "id2", label = "Make a choice:",
#'     choices = c("base", "dplyr", "data.table"),
#'     inline = TRUE, status = "danger"
#'   ),
#'   verbatimTextOutput(outputId = "res2")
#' )
#'
#' server <- function(input, output, session) {
#'
#'   output$res1 <- renderPrint({
#'     input$id1
#'   })
#'
#'   output$res2 <- renderPrint({
#'     input$id2
#'   })
#'
#' }
#'
#' shinyApp(ui = ui, server = server)
#'
#' }
#' }
awesomeRadio <- function(inputId, label, choices, selected = NULL, inline = FALSE, status = "primary", checkbox = FALSE) {
  choices <- choicesWithNames(choices)
  selected <- shiny::restoreInput(id = inputId, default = selected)
  selected <- if (is.null(selected)) {
    choices[[1]]
  } else {
    as.character(selected)
  }
  awesomeRadioTag <- htmltools::tags$div(
    id=inputId, class="form-group shiny-input-radiogroup awesome-radio-class shiny-input-container",
    class=if(inline) "shiny-input-container-inline",
    if (!is.null(label)) htmltools::tags$label(class="control-label", `for`=inputId, label, style="margin-bottom: 5px; "),
    if (!is.null(label) & !inline) tags$div(style="height: 7px;"),
    generateAwesomeRadio(inputId, choices, selected, inline, status, checkbox)
  )
  # Dep
  attachShinyWidgetsDep(awesomeRadioTag, "awesome")
}






#' @title Change the value of a radio input on the client
#'
#' @description
#' Change the value of a radio input on the client
#'
#' @param session The session object passed to function given to shinyServer.
#' @param inputId	The id of the input object.
#' @param label Input label.
#' @param choices List of values to select from (if elements of the list are named then that name rather than the value is displayed to the user)
#' @param selected	The initially selected value
#' @param status Color of the buttons
#' @param inline If TRUE, render the choices inline (i.e. horizontally)
#' @param checkbox Checkbox style
#'
#' @export
#'
#' @importFrom htmltools tagList
#'
#' @seealso \code{\link{awesomeRadio}}
#'
#' @examples
#' \dontrun{
#'
#' if (interactive()) {
#'
#' library("shiny")
#' library("shinyWidgets")
#'
#'
#' ui <- fluidPage(
#'   awesomeRadio(
#'     inputId = "somevalue",
#'     choices = c("A", "B", "C"),
#'     label = "My label"
#'   ),
#'
#'   verbatimTextOutput(outputId = "res"),
#'
#'   actionButton(inputId = "updatechoices", label = "Random choices"),
#'   textInput(inputId = "updatelabel", label = "Update label")
#' )
#'
#' server <- function(input, output, session) {
#'
#'   output$res <- renderPrint({
#'     input$somevalue
#'   })
#'
#'   observeEvent(input$updatechoices, {
#'     updateAwesomeRadio(
#'       session = session, inputId = "somevalue",
#'       choices = sample(letters, sample(2:6))
#'     )
#'   })
#'
#'   observeEvent(input$updatelabel, {
#'     updateAwesomeRadio(
#'       session = session, inputId = "somevalue",
#'       label = input$updatelabel
#'     )
#'   }, ignoreInit = TRUE)
#'
#' }
#'
#' shinyApp(ui = ui, server = server)
#'
#' }
#'
#' }
updateAwesomeRadio <- function (session, inputId, label = NULL, choices = NULL, selected = NULL,
          inline = FALSE, status = "primary", checkbox = FALSE)
{
  if (is.null(selected) && !is.null(choices))
    selected <- choices[[1]]
  if (!is.null(choices))
    choices <- choicesWithNames(choices)
  if (!is.null(selected))
    selected <- validateSelected(selected, choices, inputId)
  options <- if (!is.null(choices)) {
    format(htmltools::tagList(generateAwesomeRadio(session$ns(inputId), choices, selected, inline, status, checkbox)))
  }
  message <- dropNulls(list(label = label, options = options,
                            value = selected))
  session$sendInputMessage(inputId, message)
}






