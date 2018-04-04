//
// Created by Stefanie Muroya lei on 4/1/18.
//

#include "Interface.h"
#include "Create.h"
#include "Update.h"
#include "Select.h"
#include "Delete.h"
#include "Insert.h"


Interface::Interface(const int &obj) {

    if(obj == 0){
        Create create;
        create.process();
    }else if(obj == 1){
        Update update;
        update.process();
    }else if(obj == 2){
        Select select;
        select.process();
    }else if(obj == 3){
        Delete aDelete;
        aDelete.process();
    }else if(obj == 4){
        Insert anInsert;
        anInsert.process();
    }
}
