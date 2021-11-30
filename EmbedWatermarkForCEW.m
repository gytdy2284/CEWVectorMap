function [WatermarkedValue,EmbedWatermarkRecord] = EmbedWatermarkForCEW(fileID,OriginalValue, EncryptStepLength, WatermarkStepLength,WatermarkSequence,WatermarkLength,EmbedWatermarkRecord)
    ValueForHash = round(double(OriginalValue*1e5))/1e5;
    MappedValue = floor(abs(LogiHash(ValueForHash)));
    MappedIndex = round(mod(MappedValue,WatermarkLength))+1;
    if MappedIndex == 3
        tempddddd = 1;
    end
    WatermarkBit = WatermarkSequence(MappedIndex);
    TempResidue = floor(OriginalValue/EncryptStepLength);
    temp = OriginalValue - TempResidue*EncryptStepLength;
%     temp = OriginalValue;
    temp = temp - floor(temp/WatermarkStepLength)*WatermarkStepLength;
    temp = floor(temp/(WatermarkStepLength/2));
    WatermarkedValue = OriginalValue + (WatermarkBit - temp)*WatermarkStepLength/2;
    EmbedWatermarkRecord(MappedIndex,WatermarkBit+1)=EmbedWatermarkRecord(MappedIndex,WatermarkBit + 1) + 1;
%     fprintf(fileID,'ValueForHash:%18.15f MappedValue:%18.15f MappedIndex:%18.15f WatermarkBit:%18.15f TempResidue:%18.15f WatermarkedValue:%18.15f\r\n',ValueForHash,MappedValue,MappedIndex,WatermarkBit,TempResidue,WatermarkedValue);

end

