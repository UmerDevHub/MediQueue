import os
import sys
import uuid
from datetime import datetime, timedelta, timezone

# Add parent directory to sys.path so we can import app modules
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.db.database import supabase

def seed():
    print("Initializing Resilient Supabase Seeder...")
    
    # 1. Clear existing records to start fresh
    print("Clearing existing tables (Cascade)...")
    try:
        supabase.table("appointments").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        supabase.table("slots").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        supabase.table("doctors").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        supabase.table("queue").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        supabase.table("incidents").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        supabase.table("hospitals").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        
        # Clear users table except the one that references auth.users
        supabase.table("users").delete().neq("id", "9672d842-b2c2-46dd-ba8a-37c0e4f949a2").execute()
        print("Existing data cleared successfully.")
    except Exception as e:
        print(f"Warning during clearing: {e}")

    # 2. Insert Hospitals
    print("Creating hospitals...")
    hospitals = [
        {
            "id": "38c92a2a-b032-4415-9988-bb735dbd2b1f",
            "name": "Mayo Hospital",
            "address": "Hospital Road, Lahore",
            "lat": 31.5725,
            "lng": 74.3106,
            "emergency_available": True,
            "avg_service_time": 12,
            "current_queue_size": 2
        },
        {
            "id": "48c92a2a-b032-4415-9988-bb735dbd2b1f",
            "name": "Shifa International Hospital",
            "address": "Pitras Bukhari Rd, H-8/4, Islamabad",
            "lat": 33.6844,
            "lng": 73.0479,
            "emergency_available": True,
            "avg_service_time": 15,
            "current_queue_size": 1
        }
    ]
    
    hosp_resp = supabase.table("hospitals").insert(hospitals).execute()
    print("Hospitals created.")

    # 3. Create/Ensure the single valid patient user in public.users
    print("Creating/Ensuring the patient user...")
    patient_id = "9672d842-b2c2-46dd-ba8a-37c0e4f949a2"
    patient_data = {
        "id": patient_id,
        "name": "Majid Ali",
        "phone": "+92 300 1111111",
        "email": "speedydulix@gmail.com",
        "role": "user"
    }
    
    try:
        supabase.table("users").upsert(patient_data).execute()
        print("Patient user set in public.users.")
    except Exception as e:
        print(f"Failed to upsert patient: {e}")

    # 4. Create Doctor Clinical records (seeded directly into doctors table)
    print("Creating doctor records...")
    doctor_aisha_id = "f059fa2d-7c2a-4a6c-8a1a-3e114dbd713c"
    doctor_zain_id = "e011fa2d-7c2a-4a6c-8a1a-3e114dbd713c"
    
    doctors = [
        {
            "id": doctor_aisha_id,
            "hospital_id": "38c92a2a-b032-4415-9988-bb735dbd2b1f",
            "name": "Dr. Aisha Khan",
            "specialization": "Cardiology",
            "license_number": "MQ-DOC-98219",
            "availability": True
        },
        {
            "id": doctor_zain_id,
            "hospital_id": "38c92a2a-b032-4415-9988-bb735dbd2b1f",
            "name": "Dr. Zain Malik",
            "specialization": "Pediatrics",
            "license_number": "MQ-DOC-77112",
            "availability": True
        }
    ]
    
    doc_resp = supabase.table("doctors").insert(doctors).execute()
    print("Doctors created.")

    # 5. Create Slots for Doctors
    print("Creating consulting time slots...")
    now = datetime.now(timezone.utc)
    slots = []
    
    # Slots for Dr. Aisha Khan
    slots.append({
        "id": "a111fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
        "doctor_id": doctor_aisha_id,
        "start_time": (now + timedelta(hours=2)).isoformat(),
        "end_time": (now + timedelta(hours=2, minutes=30)).isoformat(),
        "is_booked": True
    })
    slots.append({
        "id": "a222fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
        "doctor_id": doctor_aisha_id,
        "start_time": (now + timedelta(hours=3)).isoformat(),
        "end_time": (now + timedelta(hours=3, minutes=30)).isoformat(),
        "is_booked": True
    })
    slots.append({
        "id": "a333fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
        "doctor_id": doctor_aisha_id,
        "start_time": (now + timedelta(hours=4)).isoformat(),
        "end_time": (now + timedelta(hours=4, minutes=30)).isoformat(),
        "is_booked": False
    })
    
    # Slots for Dr. Zain Malik
    slots.append({
        "id": "b111fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
        "doctor_id": doctor_zain_id,
        "start_time": (now + timedelta(hours=1)).isoformat(),
        "end_time": (now + timedelta(hours=1, minutes=30)).isoformat(),
        "is_booked": False
    })
    slots.append({
        "id": "b222fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
        "doctor_id": doctor_zain_id,
        "start_time": (now + timedelta(hours=2)).isoformat(),
        "end_time": (now + timedelta(hours=2, minutes=30)).isoformat(),
        "is_booked": False
    })

    slot_resp = supabase.table("slots").insert(slots).execute()
    print("Created slots successfully.")

    # 6. Create Real Booked Appointments for Majid Ali
    print("Creating active enqueued appointments...")
    appointments = [
        {
            "id": "c111fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
            "user_id": patient_id,
            "doctor_id": doctor_aisha_id,
            "slot_id": "a111fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
            "status": "booked"
        },
        {
            "id": "c222fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
            "user_id": patient_id,
            "doctor_id": doctor_aisha_id,
            "slot_id": "a222fa2d-7c2a-4a6c-8a1a-3e114dbd713c",
            "status": "booked"
        }
    ]
    
    appt_resp = supabase.table("appointments").insert(appointments).execute()
    print("Created real enqueued appointments in Supabase.")
    print("Seeding Complete!")

if __name__ == "__main__":
    seed()
