$(function() {

  $("#enrollments")
    .DataTable({
    bAutoWidth: false,
    lengthChange: false, // disable show per page
    processing: true,
    deferLoading: 10,
    serverSide: true,
    ajax: $(this).data('url'),
    language: {
      searchPlaceholder: 'Filter results',
      zeroRecords: 'No results were found',
      infoFiltered: ''
    },
    columnDefs: [
      { orderData: [0, 1], targets: 0, sortable: true } 
    ]
  });

  $('.dataTables_filter input').on('keydown', function(event) {
    var key = event.keyCode || event.charCode;

    if( key == 8 || key == 46 ) {
        str = $(".dataTables_filter input").val();
        str = str.substring(0, str.length - 1);
        $(".dataTables_filter input").val(str);
        return false;
    }


  });


});
