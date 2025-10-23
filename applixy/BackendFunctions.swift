//
//  BackendFunctions.swift
//  applixy
//
//  Created by Parissa Teli on 10/21/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

 // MARK: - Model
struct ScholarshipPost: Identifiable {
    let id: String
    let name: String
    let description: String
    let organization: String
    let awardAmount: Int?
    let applicationDeadline: String?
    let website: String?
    let isActive: Bool
}

func postOpportunity(collection: String){
    guard let uid = Auth.auth().currentUser?.uid else { //Checks if the uid is valid
        print("User not signed in")
        return
    }
    //print(uid) //If you want to use the generated user id
    let db = Firestore.firestore()
    let user = "myusername" //We can replace this with a proper login later
    
    //Some placeholder data
    //[String: Any] is a dictionary that has Strings for the keys but the values can be all different types
    
    //REPLACE the post data should be whatever the user inputs to the post opportunity page... placeholder values have been added for now
    let postData: [String: Any] = [
        "active": true,
        "application_deadline": "November 13",
        "award_amount": 30000,
        "description": "Description of the scholarship",
        "name": "title",
        "organization": "Some foundation",
        "target_demographic": ["low-income", "high-achievers", "first-generation"],
        "website": "Website link",
        "timestamp": FieldValue.serverTimestamp()
    ]
    db.collection(collection) //change this based on the desired collection (for us should be either mentor, resources, or scholarship)
      //.document(uid) //You can add these lines if you want to orginize a larger tree
      //.collection("messages")
      .addDocument(data: postData) { error in
        if let error = error {
            print("Post failed: \(error.localizedDescription)")
        } else {
            print("Message posted successfully!")
        }
    }
    
    
    
}

struct MentorPost: Identifiable {
    let id: String
    let name: String
    let description: String
    let organization: String
    let phone: String
    let website: String?
    let isActive: Bool
}

/*To Reference this Function Do the following:
 
 Button(action: {
     postMentor(collection: "mentors")
 }) {
     Label("Add Mentor", systemImage: "plus")
 }
 
 */

func postMentor(collection: String){
    guard let uid = Auth.auth().currentUser?.uid else { //Checks if the uid is valid
        print("User not signed in")
        return
    }
    //print(uid) //If you want to use the generated user id
    let db = Firestore.firestore()
    let user = "myusername" //We can replace this with a proper login later
    
    //Some placeholder data
    //[String: Any] is a dictionary that has Strings for the keys but the values can be all different types
    
    //REPLACE the post data should be whatever the user inputs to the post opportunity page... placeholder values have been added for now
    let postMentorData: [String: Any] = [
        "active": true,
        "description": "Expert in their field of... ",
        "email": "mentor@email",
        "name": "Mentor",
        "phone": "1234567890",
        

    ]
    db.collection(collection) //change this based on the desired collection (for us should be either mentor, resources, or scholarship)
      //.document(uid) //You can add these lines if you want to orginize a larger tree
      //.collection("messages")
      .addDocument(data: postMentorData) { error in
        if let error = error {
            print("Post failed: \(error.localizedDescription)")
        } else {
            print("Message posted successfully!")
        }
    }
    
    
    
}


/*How to call listener
 
 var listener: ListenerRegistration?

 // Start listening
 listener = startScholarshipListener { posts in
     print("Live update: \(posts.count) scholarships found")
 }

 // Stop listening when done (to avoid leaks)
 listener?.remove()

 
 */


// Listens to scholarship data and reads from database
func startScholarshipListener(onUpdate: @escaping ([ScholarshipPost]) -> Void) -> ListenerRegistration {
    let db = Firestore.firestore()

    let listener = db.collection("scholarship")
        .order(by: "timestamp", descending: true)
        .addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening: \(error.localizedDescription)")
                onUpdate([])
                return
            }

            let posts = snapshot?.documents.compactMap { doc -> ScholarshipPost? in
                let data = doc.data()
                return ScholarshipPost(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "Untitled",
                    description: data["description"] as? String ?? "",
                    organization: data["organization"] as? String ?? "",
                    awardAmount: (data["award_amount"] as? Int) ?? 0,
                    applicationDeadline: data["application_deadline"] as? String ?? "",
                    website: data["website"] as? String ?? "",
                    isActive: data["active"] as? Bool ?? false
                )
            } ?? []

            onUpdate(posts)
        }

    return listener
}
