

<!-- 




<!-- $mail = new PHPMailer;
$mail->isSMTP();
$mail->Host = "smtp-relay.gmail.com";
$mail->SMTPAuth = true;
$mail->SMTPSecure = "ssl";
$mail->Username = "noreply@deestone.com";
$mail->Password = "tckpwktdnrpahmem";
$mail->CharSet = "utf-8";
$mail->Port = 465;
$mail->From = "noreply@deestone.com";
$mail->FromName = "noreply@deestone.com";
$mail->isHTML(true);
$mail->Subject = 'test';
$mail->Body = '<form action="http://arryn:81/ea" method="post">
                  <input type="checkbox" name="a[]"> Name 1 <br> 
                  <input name="a[]" type="checkbox"> Name 2 <br> 
                  <input type="submit" value="approve">
              </from>';
$mail->addAddress('surapon_o@deestone.com');
$mail->addAddress('surapon_o@deestone.com');

$mail->send(); -->


<!DOCTYPE html>
<html lang="en">
<head>
    <title id='Description'>The sample shows how to customize fields in the ever present row. The first Text Field in the ever present row is disabled.</title>
    <link rel="stylesheet" href="../../jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="../../scripts/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxgrid.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxgrid.filter.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxgrid.sort.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxgrid.selection.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxgrid.edit.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxgrid.columnsresize.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxradiobutton.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxnumberinput.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../../jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="../../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../../scripts/demos.js"></script>
    <script type="text/javascript" src="generatedata.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var data = generatedata(20);
            var source =
            {
                localdata: data,
                datafields:
                [
                    { name: 'name', type: 'string' },
                    { name: 'productname', type: 'string' },
                    { name: 'available', type: 'bool' },
                    { name: 'date', type: 'date' },
                    { name: 'quantity', type: 'number' }
                ],
                datatype: "array"
            };
            var dataAdapter = new $.jqx.dataAdapter(source);
            var getSourceAdapter = function (name) {
                var source =
                {
                    localdata: data,
                    datafields:
                    [
                        { name: 'name', type: 'string' },
                        { name: 'productname', type: 'string' }
                    ],
                    datatype: "array"
                };
                var fields = new Array();
                fields.push(name);
                var dataAdapter = new $.jqx.dataAdapter(source, { autoBind: true, autoSort: true, uniqueDataFields: fields, autoSortField: name });
                return dataAdapter.records;
            }
            $("#jqxgrid").jqxGrid(
            {
                width: 850,
                filterable: true,
                source: dataAdapter,
                showeverpresentrow: true,
                everpresentrowposition: "top",
                editable: true,
                everpresentrowactionsmode: "columns",
                columns: [
                  {
                      text: 'Name', columntype: 'textbox', filtertype: 'input', datafield: 'name', width: 215,
                      createEverPresentRowWidget: function (datafield, htmlElement, popup, addCallback) {
                          var inputTag = $("<input style='border: none;'/>").appendTo(htmlElement);
                          inputTag.jqxInput({ popupZIndex: 99999999, placeHolder: "Enter Name: ", source: getSourceAdapter("name"), displayMember: 'name', width: '100%', height: 30 });
                          $(document).on('keydown.name', function (event) {
                              if (event.keyCode == 13) {
                                  if (event.target === inputTag[0]) {
                                      addCallback();
                                  }
                              }
                          });
                          return inputTag;
                      },
                      initEverPresentRowWidget: function (datafield, htmlElement) {
                      },
                      validateEverPresentRowWidgetValue: function (datafield, value, rowValues) {
                          if (!value || (value && value.length < 5)) {
                              return { message: "Entered value should be more than 5 characters", result: false };
                          }
                          return true;
                      },
                      getEverPresentRowWidgetValue: function (datafield, htmlElement, validate) {
                          var value = htmlElement.val();
                          return value;
                      },
                      resetEverPresentRowWidgetValue: function (datafield, htmlElement) {
                          htmlElement.val("");
                      }
                  },
                  {
                      text: 'Product', filtertype: 'checkedlist', datafield: 'productname', width: 220,
                      createEverPresentRowWidget: function (datafield, htmlElement, popup, addCallback) {
                          var inputTag = $("<div style='border: none;'></div>").appendTo(htmlElement);
                          inputTag.jqxDropDownList({ popupZIndex: 99999999, placeHolder: "Enter Product: ", source: getSourceAdapter("productname"), displayMember: 'productname', width: '100%', height: 30 });
                          $(document).on('keydown.productname', function (event) {
                              if (event.keyCode == 13) {
                                  if (event.target === inputTag[0]) {
                                      addCallback();
                                  }
                                  else if ($(event.target).ischildof(inputTag)) {
                                      addCallback();
                                  }
                              }
                          });
                          return inputTag;
                      },
                      getEverPresentRowWidgetValue: function (datafield, htmlElement, validate) {
                          var selectedItem = htmlElement.jqxDropDownList('getSelectedItem');
                          if (!selectedItem)
                              return "";
                          var value = selectedItem.label;
                          return value;
                      },
                      resetEverPresentRowWidgetValue: function (datafield, htmlElement) {
                          htmlElement.jqxDropDownList('clearSelection');
                      }
                  },
                  {
                      text: 'Ship Date', datafield: 'date', filtertype: 'range', width: 210, cellsalign: 'right', cellsformat: 'd',
                      createEverPresentRowWidget: function (datafield, htmlElement, popup, addCallback) {
                          var inputTag = $("<div style='border: none;'></div>").appendTo(htmlElement);
                          inputTag.jqxDateTimeInput({ value: null, popupZIndex: 99999999, placeHolder: "Enter Date: ", width: '100%', height: 30 });
                          $(document).on('keydown.date', function (event) {
                              if (event.keyCode == 13) {
                                  if (event.target === inputTag[0]) {
                                      addCallback();
                                  }
                                  else if ($(event.target).ischildof(inputTag)) {
                                      addCallback();
                                  }
                              }
                          });
                          return inputTag;
                      },
                      initEverPresentRowWidget: function (datafield, htmlElement) {
                      },
                      getEverPresentRowWidgetValue: function (datafield, htmlElement, validate) {
                          var value = htmlElement.val();
                          return value;
                      },
                      resetEverPresentRowWidgetValue: function (datafield, htmlElement) {
                          htmlElement.val(null);
                      }
                  },
                  {
                      text: 'Qty.', datafield: 'quantity', filtertype: 'number', cellsalign: 'right',
                      createEverPresentRowWidget: function (datafield, htmlElement, popup, addCallback) {
                          var inputTag = $("<div style='border: none;'></div>").appendTo(htmlElement);
                          inputTag.jqxNumberInput({ inputMode: 'simple', decimalDigits: 0, width: '100%', height: 30 });
                          $(document).on('keydown.qty', function (event) {
                              if (event.keyCode == 13) {
                                  if (event.target === inputTag[0]) {
                                      addCallback();
                                  }
                                  else if ($(event.target).ischildof(inputTag)) {
                                      addCallback();
                                  }
                              }
                          });
                          return inputTag;
                      },
                      initEverPresentRowWidget: function (datafield, htmlElement) {
                      },
                      validateEverPresentRowWidgetValue: function (datafield, value, rowValues) {
                          if (parseInt(value) < 0) {
                              return { message: "Entered value should be positive number", result: false };
                          }
                          return true;
                      },
                      getEverPresentRowWidgetValue: function (datafield, htmlElement, validate) {
                          var value = htmlElement.val();
                          if (value == "") value = 0;
                          return parseInt(value);
                      },
                      resetEverPresentRowWidgetValue: function (datafield, htmlElement) {
                          htmlElement.val("");
                      }
                  },
                { text: '', datafield: 'addButtonColumn', width: 50 },
                  { text: '', datafield: 'resetButtonColumn', width: 50 }
                ]
            });
            $("#top").jqxRadioButton({ checked: true });
            $("#bottom").jqxRadioButton();
            $("#top").on('checked', function () {
                $("#jqxgrid").jqxGrid('everpresentrowactions', 'add reset');
            });
            $("#bottom").on('checked', function () {
                $("#jqxgrid").jqxGrid('everpresentrowactions', 'addBottom reset');
            });
        });
    </script>
</head>
<body>
    <div id="jqxgrid">
    </div>
    <br />
    <div id="top">Add New Row to Top</div>
    <div id="bottom">Add New Row to Bottom</div>
</body>
</html>