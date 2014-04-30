function null = closeall()
    display('Closing all connections...')
    out = instrfind;
    fclose(out);
    delete(out);
    clear all
    display('Connections closed.')
end