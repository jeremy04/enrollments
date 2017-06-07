$(function() {

  $("#courses_list").dataTable({
    bAutoWidth: false,
    lengthChange: false, // disable show per page
    processing: true,
    serverSide: true,
    ajax: "/",
    language: {
      search: "_INPUT_",
      searchPlaceholder: 'Filter results',
      zeroRecords: 'No results were found',
      infoFiltered: ''
    },
    columnDefs: [
      { targets: 0, sortable: true } 
    ]
  });

});
