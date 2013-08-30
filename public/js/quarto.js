$(function() {
  var $board  = $('table#board');
  var $stash  = $('ul#stash');
  var $form   = $('form')

  $board.on('click', 'td', function() {
    var $old_td = $board.find('img.placed-piece').closest('td')
    var $img    = $stash.find('li.place-me img').first();
    var $td     = $(this);

    $content = $img.clone();
    $content.addClass('placed-piece');

    if ($old_td.length) $old_td.html($old_td.data('old-content'));

    $td.data('old-content', $td.html());
    $td.html($content)
  });

  $stash.on('click', 'li.choose-me', function(){
    $stash.find('li.selected-piece').removeClass('selected-piece');

    var $li = $(this);

    $li.addClass('selected-piece');
  });

  $form.on('submit', function(e) {
    var $td = $board.find('.placed-piece').closest('td')
    var $li = $stash.find('.selected-piece img')
    var i, j, k;

    if ($td.length && $li.length) {
      i = $td.data('i');
      j = $td.data('j');
      k = $li.data('k')
    } else {
      return false;
    }

    $form.find('input[name="i"]').val(i);
    $form.find('input[name="j"]').val(j);
    $form.find('input[name="k"]').val(k);
  });
});
