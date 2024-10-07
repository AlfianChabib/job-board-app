-- CreateEnum
CREATE TYPE "UserType" AS ENUM ('JobSeeker', 'Company');

-- CreateEnum
CREATE TYPE "JobType" AS ENUM ('PartTime', 'FullTime', 'Contract');

-- CreateEnum
CREATE TYPE "ApplicationStatus" AS ENUM ('Offer', 'Accepted', 'Interview', 'Successful', 'Unsuccessful');

-- CreateEnum
CREATE TYPE "InterviewType" AS ENUM ('Online', 'Offline');

-- CreateEnum
CREATE TYPE "InterviewStatus" AS ENUM ('Sending', 'Accept', 'Canceled', 'Rescheduling', 'Finished');

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "role" "UserType" NOT NULL DEFAULT 'JobSeeker',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuthDetail" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "hashPassword" TEXT,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verificationCode" TEXT,
    "userId" INTEGER,

    CONSTRAINT "AuthDetail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RefreshToken" (
    "id" SERIAL NOT NULL,
    "hashToken" TEXT NOT NULL,
    "revoked" BOOLEAN NOT NULL DEFAULT false,
    "expiry" TIMESTAMP(3) NOT NULL,
    "authDetailId" INTEGER,

    CONSTRAINT "RefreshToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserProfile" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "username" TEXT,
    "image" TEXT,
    "summary" TEXT,

    CONSTRAINT "UserProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserExperience" (
    "id" SERIAL NOT NULL,
    "userProfileId" INTEGER NOT NULL,
    "jobTitle" TEXT NOT NULL,
    "companyName" TEXT NOT NULL,
    "description" TEXT,
    "started" TIMESTAMP(3) NOT NULL,
    "ended" TIMESTAMP(3),
    "stillInRole" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "UserExperience_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserSkill" (
    "id" SERIAL NOT NULL,
    "userProfileId" INTEGER NOT NULL,
    "skillTitle" TEXT NOT NULL,

    CONSTRAINT "UserSkill_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserClassification" (
    "id" SERIAL NOT NULL,
    "userProfileId" INTEGER NOT NULL,
    "classificationId" INTEGER,
    "subClassificaionId" INTEGER,

    CONSTRAINT "UserClassification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserEducation" (
    "id" SERIAL NOT NULL,
    "userProfileId" INTEGER NOT NULL,
    "courseOrQualification" TEXT NOT NULL,
    "institution" TEXT NOT NULL,
    "isComplete" BOOLEAN NOT NULL DEFAULT false,
    "finishedYear" TEXT,
    "description" TEXT,

    CONSTRAINT "UserEducation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserResume" (
    "id" SERIAL NOT NULL,
    "userProfileId" INTEGER NOT NULL,
    "resumeUrl" TEXT,

    CONSTRAINT "UserResume_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompanyProfile" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "companyName" TEXT,
    "logo" TEXT,
    "address" TEXT,
    "description" TEXT,

    CONSTRAINT "CompanyProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "jobs" (
    "id" SERIAL NOT NULL,
    "companyProfileId" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "requirements" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "jobType" "JobType" NOT NULL DEFAULT 'PartTime',
    "registrationDeadline" TIMESTAMP(3) NOT NULL,
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "jobs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "applications" (
    "id" SERIAL NOT NULL,
    "jobId" INTEGER,
    "userProfileId" INTEGER,
    "status" "ApplicationStatus" NOT NULL DEFAULT 'Offer',
    "resume" TEXT NOT NULL,

    CONSTRAINT "applications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Interview" (
    "id" SERIAL NOT NULL,
    "interviewSchedule" TIMESTAMP(3),
    "rescheduleInterview" TIMESTAMP(3),
    "interviewType" "InterviewType" DEFAULT 'Online',
    "interviewUrl" TEXT,
    "interviewLocation" TEXT,
    "interviewStatus" "InterviewStatus" DEFAULT 'Sending',
    "applicationId" INTEGER,

    CONSTRAINT "Interview_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClassificationInfo" (
    "id" SERIAL NOT NULL,
    "classificationId" INTEGER,
    "subClassificationId" INTEGER,
    "jobId" INTEGER NOT NULL,

    CONSTRAINT "ClassificationInfo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "classifications" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,

    CONSTRAINT "classifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subClassifications" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "classificationId" INTEGER,

    CONSTRAINT "subClassifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Skill" (
    "id" SERIAL NOT NULL,
    "Text" TEXT NOT NULL,

    CONSTRAINT "Skill_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "AuthDetail_email_key" ON "AuthDetail"("email");

-- CreateIndex
CREATE UNIQUE INDEX "AuthDetail_userId_key" ON "AuthDetail"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UserProfile_userId_key" ON "UserProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UserResume_userProfileId_key" ON "UserResume"("userProfileId");

-- CreateIndex
CREATE UNIQUE INDEX "CompanyProfile_userId_key" ON "CompanyProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Interview_applicationId_key" ON "Interview"("applicationId");

-- CreateIndex
CREATE UNIQUE INDEX "ClassificationInfo_jobId_key" ON "ClassificationInfo"("jobId");

-- AddForeignKey
ALTER TABLE "AuthDetail" ADD CONSTRAINT "AuthDetail_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RefreshToken" ADD CONSTRAINT "RefreshToken_authDetailId_fkey" FOREIGN KEY ("authDetailId") REFERENCES "AuthDetail"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserProfile" ADD CONSTRAINT "UserProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserExperience" ADD CONSTRAINT "UserExperience_userProfileId_fkey" FOREIGN KEY ("userProfileId") REFERENCES "UserProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSkill" ADD CONSTRAINT "UserSkill_userProfileId_fkey" FOREIGN KEY ("userProfileId") REFERENCES "UserProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserClassification" ADD CONSTRAINT "UserClassification_userProfileId_fkey" FOREIGN KEY ("userProfileId") REFERENCES "UserProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserClassification" ADD CONSTRAINT "UserClassification_classificationId_fkey" FOREIGN KEY ("classificationId") REFERENCES "classifications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserClassification" ADD CONSTRAINT "UserClassification_subClassificaionId_fkey" FOREIGN KEY ("subClassificaionId") REFERENCES "subClassifications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserEducation" ADD CONSTRAINT "UserEducation_userProfileId_fkey" FOREIGN KEY ("userProfileId") REFERENCES "UserProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserResume" ADD CONSTRAINT "UserResume_userProfileId_fkey" FOREIGN KEY ("userProfileId") REFERENCES "UserProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompanyProfile" ADD CONSTRAINT "CompanyProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "jobs_companyProfileId_fkey" FOREIGN KEY ("companyProfileId") REFERENCES "CompanyProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "applications" ADD CONSTRAINT "applications_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "jobs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "applications" ADD CONSTRAINT "applications_userProfileId_fkey" FOREIGN KEY ("userProfileId") REFERENCES "UserProfile"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Interview" ADD CONSTRAINT "Interview_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "applications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClassificationInfo" ADD CONSTRAINT "ClassificationInfo_classificationId_fkey" FOREIGN KEY ("classificationId") REFERENCES "classifications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClassificationInfo" ADD CONSTRAINT "ClassificationInfo_subClassificationId_fkey" FOREIGN KEY ("subClassificationId") REFERENCES "subClassifications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClassificationInfo" ADD CONSTRAINT "ClassificationInfo_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "jobs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subClassifications" ADD CONSTRAINT "subClassifications_classificationId_fkey" FOREIGN KEY ("classificationId") REFERENCES "classifications"("id") ON DELETE SET NULL ON UPDATE CASCADE;
