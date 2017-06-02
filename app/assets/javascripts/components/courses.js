$(function() {

  $("#courses_list").dataTable({
    bAutoWidth: false,
    lengthChange: false, // disable show per page
    pageLength: 15,
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
