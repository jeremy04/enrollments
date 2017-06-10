$(function() {

  $("#enrollments").dataTable({
    bAutoWidth: false,
    lengthChange: false, // disable show per page
    processing: true,
    serverSide: true,
    ajax: $(this).data('url'),
    language: {
      search: "_INPUT_",
      searchPlaceholder: 'Filter results',
      zeroRecords: 'No results were found',
      infoFiltered: ''
    },
    columnDefs: [
      { orderData: [0, 1], targets: 0, sortable: true } 
    ]
  });

});
