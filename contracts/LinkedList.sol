pragma solidity ^0.4.21;

/**
 * @title LinkedList
 * @dev The LinkedList library is a contract that implements linked list structure
 * on a tuples of unsigned integers and addresses. The list is sorted by unsigned
 * intergers and pointed by aaddresses.
 */
library LinkedList {

    // Element structure
    struct Element {
        uint data;
        address previous;
        address next;
    }

    // Linked list of elements
    struct List {
        uint numElements;
        address tail;
        address head;
        mapping (address => Element) list;
     }

     // Create a new element and add into the linked list. It is sorted by data(uint) field
    function newElement(List storage self, address _id, uint _data) internal returns (bool){

        self.list[_id].data = _data;

        // Link a new element
        // Two cases - linked list map empty or not
        if (self.numElements == 0) {

            //update state
            self.tail = _id;
            self.head = _id;
            self.list[_id].previous = _id;
            self.list[_id].next = _id;
            self.numElements++;
            return true;

        } else {

            address index = self.head;

            // Head case
            if (self.list[index].data < self.list[_id].data){
                //itself
                self.list[_id].previous = _id;
                self.list[_id].next = index;
                //next
                self.list[index].previous = _id;
                //update state
                self.head = _id;
                self.numElements++;
                return true;
            }

            // Body case
            index = self.list[index].next;

            for (uint i = 1; i < self.numElements; i++){

                if (self.list[index].data >= self.list[_id].data){
                    index = self.list[index].next;
                } else {
                    //previous
                    self.list[self.list[index].previous].next = _id;
                    //itself
                    self.list[_id].previous = self.list[index].previous;
                    self.list[_id].next = index;
                    //next
                    self.list[index].previous = _id;
                    //update state
                    self.numElements++;
                    return true;
                }

            }

            //Tail case
            if (self.list[index].data >= self.list[_id].data){
                //previous
                self.list[index].next = _id;
                //itself
                self.list[_id].previous = index;
                self.list[_id].next = _id;

                //update state
                self.tail = _id;
                self.numElements++;
                return true;
            }

        }
        // In case of failure.
        return false;
    }

    // Delete and existent element of the linked list
    function deleteElement(List storage self, address _id) internal {
        //previous
        self.list[self.list[_id].next].previous = self.list[_id].previous;
        //next
        self.list[self.list[_id].previous].next =  self.list[_id].next;
        //delet itself
        self.list[_id].next = address(0);
        self.list[_id].previous = address(0);
        self.list[_id].data = 0;
        //update state
        self.numElements--;
    }

    // Modify an existent element of the linked list
    function modifyElement(List storage self, address _id, uint _data) internal {
        deleteElement(self, _id);
        newElement(self, _id, _data);
    }

    // Add an element to the linked list without knowing if exists or not
    function addElement(List storage self, address _id, uint _data) internal {
        if (self.list[_id].data == 0){
            newElement(self, _id, _data);
        } else {
            modifyElement(self, _id, _data);
        }
    }

    // Given an id, it returns an element data and its pointers (data, previous, next)
    function getElement(List storage self, address _id) internal view returns (uint, address, address) {
       return (self.list[_id].data, self.list[_id].previous, self.list[_id].next);
    }

}
