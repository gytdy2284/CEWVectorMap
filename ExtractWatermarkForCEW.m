function [WatermarkBitIndex,WatermarkBit] = ExtractWatermarkForCEW(fileID,Value,EncryptStepLength,WatermarkStepLength,WatermarkLength)
    ValueForHash = round(double(Value*1e5))/1e5;
    MappedValue = floor(abs(LogiHash(ValueForHash)));
    WatermarkBitIndex = round(mod(MappedValue,WatermarkLength))+1;
    if WatermarkBitIndex == 3
        tempddddd = 1;
    end
    TempResidue = floor(Value/EncryptStepLength);
    temp = Value - TempResidue*EncryptStepLength;
    temp = temp - floor(temp/WatermarkStepLength)*WatermarkStepLength;
    WatermarkBit = floor(temp/(WatermarkStepLength/2));
    fprintf(fileID,'ValueForHash:%18.15f MappedValue:%18.15f WatermarkBitIndex:%18.15f TempResidue:%18.15f WatermarkBit:%18.15f \r\n',ValueForHash,MappedValue,WatermarkBitIndex,temp,WatermarkBit);
end

