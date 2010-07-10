Event.observe(window, 'load', init, false);


function init() {
    var elements;

    // Fade away notifications
    var note = $$('li.flash')[0];
    if (note) note.fade({duration:3.0});
    
    elements = $$('ul li');
    elements.each( function(el) { ajaxify(el); });
    
    // focus on the first input field with class 'focus'
    input_forms = $$('form.new_todo_form');
    input_forms.each( function(el) { ajaxifyForm(el); });
}


function editInPlace(el) {
    var li = el.up('li');
    var id = li.down('input[type=checkbox]').value;
    var form = new Element('form');
    var input = new Element('input', {type:"text", value:el.innerHTML});
    input.onblur = function() { cancelEdit(li); };
    form.insert(input);
    form.onsubmit = function() {
	new Ajax.Updater( li, '/todos/'+id,
    { method:"put",
      parameters:{ id:id, 'todo[label]':input.value},
      onComplete: function() { ajaxify(li); }
    });
	return false;
    }
    el.hide();
    el.insert({after:form});
    input.focus();
}


function cancelEdit(li) {
    var form = li.down('form');
    form.remove();
    var label = li.down('span.label');
    label.show();
}



function ajaxify(li) {
    var input = li.down('input[type=checkbox]');
    if (input) {
	input.observe('change', function() { lineCheck(this); });
	if (input.checked) {
	    li.addClassName('done');
	} else {
	    li.removeClassName('done');
	}
    }
    var label = li.down('span.label');
    if (label) {
	label.onclick = function() { editInPlace(this); return false;};
    }
    // capture delete action link
    var del = li.down('span.delete a');
    if (del) {
	del.onclick = function() {
	    new Ajax.Request('/todos/'+input.value, {
		    method: 'delete',
		    onSuccess: function() { li.fade({duration:1}); },
		    onFailure: function() { alert('Unable to delete item.'); }
		});
	    return false; };
    }
}




function ajaxifyForm(form) {
	var input = form.down('input[type=text]');
	input.observe('focus', function() {
		if (input.value==input.getAttribute('alt')) input.value = "";
	});
	input.observe('blur', function() {
		if (input.value.strip()=="") input.value = input.getAttribute('alt');
	});
	form.onsubmit = function() {
		new Ajax.Request('/todos', {
		method: 'post',
		parameters: form.serialize(true),
		onSuccess: function(transport) {
			// enter response into todolist
			var li = new Element('li').update(transport.responseText);
			form.up().insert({after:li});
			input.value = "";
			ajaxify(li);
		},
		onFailure: function() {
			// display error message
			alert('error');
		}
	});
	return false;
	};
}



// called by the checkbox
function lineCheck(F) {
    var li = F.up('li');
    var action_url = '/todos/'+F.value;
    new Ajax.Request(action_url, {
	    method: 'put',
		parameters: { 'todo[setdone]':F.checked },
		onSuccess: function(transport) {
		li.update(transport.responseText);
		ajaxify(li);
	    },
		onFailure: function(){ alert('Something went wrong...'); F.checked = !F.checked }
    });
    return false;
}





