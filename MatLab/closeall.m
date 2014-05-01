function null = closeall()
    display('Closing all connections...')
    out = instrfind;
    try
        fclose(out);
    catch
        display('No connections to close.')
        delete(out);
        clear all
        return;
    end
    delete(out);
    clear all
    display('Connections closed.')
end