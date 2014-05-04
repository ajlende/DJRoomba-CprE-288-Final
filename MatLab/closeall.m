%Script for closing any and all serial objects
function null = closeall()
    %User info
    display('Closing all connections...')
    
    %Get list of all connected instruments (serial objects)
    out = instrfind;
    try
        %Close these objects
        fclose(out);
    catch
        %If there were no objects to close
        display('No connections to close.')
        
        %Delete and clear our object
        delete(out);
        clear all
        return;
    end
    
    %Delete and clear our object, let user know that there was a connection
    %that was closed
    delete(out);
    clear all
    display('Connections closed.')
end