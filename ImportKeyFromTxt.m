for i=0:9
    keyfilename = append('.\keys\100wkey',num2str(i),'.txt');
    saveFileName = append('.\keys\100wkey',num2str(i), '.mat');
    disp(saveFileName);
    keymatrix = readmatrix(keyfilename);
    keyTransMatrix = keymatrix(:);
    save(saveFileName,'keyTransMatrix');
end
