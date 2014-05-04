function appendeditbox( str,handles,hObject )

%Used to display messages in our GUI.  Now simply displays messages in
%console.
display(str)
%handles.message = sprintf('%3d: %s\n%s',handles.count,str,handles.message);
%handles.count = handles.count + 1;
%guidata(hObject, handles);
%set(handles.editmsg,'String',handles.message)
end

