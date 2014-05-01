function null = closeall()
    display('Closing all connections...')
    out = instrfind;
    try
        fclose(out);
    catch
        display('No connections to close.')
        return;
    end
    delete(out);
    clear all
    display('Connections closed.')
end