# jerias_math

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

import random
from django.utils import timezone
from jerias_production.models import Group, Person, AppUser, GroupPerson
persons = []
def create_sample_data():
    # Create 5 sample Persons
   
    for i in range(5):
        person = Person.objects.create(
            lastName=f'Doe{i}',
            firstName=f'John{i}',
            startDate=timezone.now(),
            status=1,
            phone=f'123456789{i}',
            email=f'john.doe{i}@example.com',
            parentPhone1=f'987654321{i}',
            parentPhone2=f'987654322{i}',
            dob=timezone.now(),
            userId=f'johndoe{i}',
        )

        person.save()
        persons.append(person)


    # Create the admin AppUser


    # Create 5 sample Groups and establish relations
    groups = []
    for i in range(5):
        group = Group.objects.create(
            name=f'Sample Group {i+1}',
            teacherId=1,#f'teacher{i+1}',
            startDate=timezone.now(),
            endDate=timezone.now(),
            weekDays='Monday, Wednesday, Friday',
            type=1,
            status=1,
            #lastUpdatedBy=admin_person=admin_person,
            created=timezone.now(),
            lastUpdated=timezone.now(),
            ##lastUpdatedBy=admin_person=admin_person
        )
        groups.append(group)

        # Create GroupPerson instances and establish relations
        for j in range(2):
            random_number = random.randint(0, 4)
            group_person = GroupPerson.objects.create(
                studentId=persons[random_number].id,
                groupId=group.id,
                #createdBy=persons[(i * 2) + j],  # Assign different persons as createdBy
                created=timezone.now(),
                lastUpdated=timezone.now(),
                #lastUpdatedBy=admin_person=persons[random_number],
                status=1,
                group=group,
                student=persons[random_number]
            )

    # Create AppUser instances for each person
    app_users = []
    for person in persons:
        app_user = AppUser.objects.create(
            uid=f'appuser_{person.id}',
            token=f'token_{person.id}',
            active=True,
            contactId=person.id,

            created=timezone.now(),
            lastUpdated=timezone.now(),
            ##lastUpdatedBy=admin_person=admin_person,
            userType='user',
            language='en',
            admin=False,
            person=person
        )
        app_users.append(app_user)



# Call the function to create sample data
create_sample_data()






from django.utils import timezone
from jerias_production.models import Group, Person, AppUser, GroupPerson
   

def create_sample_data():
    # Create 5 sample Persons
  persons = []
    for i in range(5):
        person = Person.objects.create(
            lastName=f'Doe{i}',
            firstName=f'John{i}',
            startDate=timezone.now(),
            status=1,
            phone=f'123456789{i}',
            email=f'john.doe{i}@example.com',
            parentPhone1=f'987654321{i}',
            parentPhone2=f'987654322{i}',
            dob=timezone.now(),
            userId=f'johndoe{i}',
        )

        person.save()
        persons.append(person)

    # Create the admin Person
    admin_person = persons[0]

    # Create the admin AppUser
    admin_app_user = AppUser.objects.create(
        uid='sampleuser1',
        token='sampletoken',
        active=True,
        contactId=1,
        #lastUpdatedBy=admin_person=admin_person,
        created=timezone.now(),
        lastUpdated=timezone.now(),
        ##lastUpdatedBy=admin_person=admin_person,
        userType='admin',
        language='en',
        admin=True,
        person=admin_person
    )

    # Create 5 sample Groups and establish relations
    groups = []
    for i in range(5):
        group = Group.objects.create(
            name=f'Sample Group {i+1}',
            teacherId=1,#f'teacher{i+1}',
            startDate=timezone.now(),
            endDate=timezone.now(),
            weekDays='Mon-Fri',
            type=1,
            status=1,
            #lastUpdatedBy=admin_person=admin_person,
            created=timezone.now(),
            lastUpdated=timezone.now(),
            ##lastUpdatedBy=admin_person=admin_person
        )
        groups.append(group)

        # Create GroupPerson instances and establish relations
        for j in range(2):
            group_person = GroupPerson.objects.create(
                studentId=persons[(i * 2) + j].id,
                groupId=group.id,
                createdBy=persons[(i * 2) + j],  # Assign different persons as createdBy
                created=timezone.now(),
                lastUpdated=timezone.now(),
                #lastUpdatedBy=admin_person=persons[(i * 2) + j],
                status=1,
                group=group,
                student=persons[(i * 2) + j]
            )

    # Create AppUser instances for each person
    app_users = []
    for person in persons:
        app_user = AppUser.objects.create(
            uid=f'appuser_{person.id}',
            token=f'token_{person.id}',
            active=True,
            contactId=person.id,
            #lastUpdatedBy=admin_person=admin_person,
            created=timezone.now(),
            lastUpdated=timezone.now(),
            ##lastUpdatedBy=admin_person=admin_person,
            userType='user',
            language='en',
            admin=False,
            person=person
        )
        app_users.append(app_user)

    # Print the created objects
    print('Admin Person:', admin_person)
    print('Admin AppUser:', admin_app_user)
    print('Sample Persons:', persons)
    print('Sample Groups:', groups)
    print('GroupPersons:', GroupPerson.objects.all())
    print('App Users:', app_users)

# Call the function to create sample data
create_sample_data()
