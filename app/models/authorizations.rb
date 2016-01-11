class Authorizations
  #Each Person can view/edit THEIR OWN enrollments, these permissions affect
  # a Person's ability to view or edit enrollments belonging to other people
  # of the same Crew
  VIEW_ENROLLMENTS = "view_enrollments"
  EDIT_ENROLLMENTS = "edit_enrollments"

  #Each Person can view/edit THEIR OWN scheduled courses, these permissions affect
  # a Person's ability to view or edit scheduled courses belonging to other people
  # of the same Crew
  VIEW_SCHEDULED_COURSES = "view_scheduled_courses"
  EDIT_SCHEDULED_COURSES = "edit_scheduled_courses"

  VIEW_OPERATIONS = "view_operations" #Allows a user to view ALL Operations
  EDIT_OPERATIONS = "edit_operations" #Allows a user to edit Operations/Rappels belonging to his own crew

  VIEW_CREWS = "view_crews"
  EDIT_CREWS = "edit_crews"
  EDIT_OWN_CREW = "edit_own_crew" #Allows a person to edit the info for the crew they currently belong to (including rosters)

  VIEW_PEOPLE = "view_people" #Allows a user to view EVERY person's "profile" page (people#show)
  EDIT_PEOPLE = "edit_people" #Allows a user to edit People who are CURRENTLY on the same Roster as the user
  CREATE_PEOPLE = "create_people" #Allows a user to create new People

  #Each Person can view/edit THEIR OWN certificates, these permissions affect
  # a Person's ability to view or edit certificates belonging to other people
  # of the same Crew
  VIEW_CERTIFICATES = "view_certificates"
  EDIT_CERTIFICATES = "edit_certificates"

  #Each Person can view/edit THEIR OWN qualifications, these permissions affect
  # a Person's ability to view or edit qualifications belonging to other people
  # of the same Crew
  VIEW_QUALIFICATIONS = "view_qualifications"
  EDIT_QUALIFICATIONS = "edit_qualifications"

  #Training Facilities are crew-specific - each crew manages their own private list of facilities.
  VIEW_TRAINING_FACILITIES = "view_training_facilities" #Allows a user to view training facilities belonging to his own crew
  EDIT_TRAINING_FACILITIES = "edit_training_facilities" #Allows a user to edit training facilities belonging to his own crew

  VIEW_STAFFING_LEVELS = "view_staffing_levels" #Allows viewing of staffing levels for all crews (staffing level summary page)
  EDIT_STAFFING_LEVELS = "edit_staffing_levels" #Allows editing of staffing levels for the user's OWN CREW

  EDIT_BUDGET = "edit_budget" #Allows a user to view & edit the requisitions belonging to their current crew.

  ACCOUNT_TYPES = ["global_admin", "crew_admin", "crewmember", "guest"]

  def self.for_global_admin
    [self::EDIT_ENROLLMENTS,
     self::EDIT_SCHEDULED_COURSES,
     self::EDIT_OPERATIONS,
     self::EDIT_CREWS,
     self::EDIT_PEOPLE,
     self::CREATE_PEOPLE,
     self::EDIT_CERTIFICATES,
     self::EDIT_QUALIFICATIONS,
     self::EDIT_STAFFING_LEVELS,
     self::EDIT_BUDGET
     ]
  end

  def self.for_crew_admin
    [self::EDIT_ENROLLMENTS,
     self::EDIT_SCHEDULED_COURSES,
     self::EDIT_OPERATIONS,
     self::EDIT_OWN_CREW,
     self::EDIT_PEOPLE,
     self::CREATE_PEOPLE,
     self::EDIT_CERTIFICATES,
     self::EDIT_QUALIFICATIONS,
     self::EDIT_STAFFING_LEVELS,
     self::EDIT_BUDGET
     ]
  end

  def self.for_crewmember
    [self::VIEW_ENROLLMENTS,
     self::VIEW_SCHEDULED_COURSES,
     self::EDIT_OPERATIONS,
     self::VIEW_CERTIFICATES,
     self::VIEW_QUALIFICATIONS,
     self::VIEW_CREWS,
     self::VIEW_PEOPLE,
     self::VIEW_STAFFING_LEVELS
     ]
  end

  def self.for_guest
    [self::VIEW_OPERATIONS,
     self::VIEW_CREWS]
  end
end
