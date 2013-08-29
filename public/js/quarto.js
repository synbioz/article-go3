$(function() {
  var $board  = $('table#board');
  var $stash  = $('ul#stash');
  var $form   = $('form')

  $board.on('click', 'td', function() {
    $board.find('img.placed-piece').remove()

    var $img = $stash.find('li.place-me img').first();
    var $td  = $(this);

    $content = $img.clone();
    $content.addClass('placed-piece');

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
